import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:tavern/src/settings.dart';
import 'package:tavern/src/sitemap.dart';
import 'package:tavern/src/tag_metadata.dart';
import 'package:tavern/src/tag_pages.dart';
import 'package:tavern/src/template.dart';
import 'package:tavern/src/template_cleanup.dart';
import 'package:test/test.dart';
import 'package:barback/barback.dart';
import 'package:tavern/src/metadata.dart';
import 'utils/test_case.dart';

main() {
  group('metadata transformer', () {
    test('extracts metadata', () async {
      // Load input file contents
      var path = 'test/fixtures/metadata.md';
      var file = new File(path);
      var contents = file.readAsStringSync();

      // Create input asset
      var assets = {new AssetId('a', 'web/foo.md'): contents};

      // Run barback
      var t = new TestCase([new Metadata()], assets);
      var barback = await t.run();

      // Check the metadata file contents
      var id = new AssetId('a', 'web/foo.metadata.json');
      var asset = await barback.getAssetById(id);
      var json = JSON.decode(await asset.readAsString());
      expect(json, containsPair('foo', 'bar'));
    });
  });
  group('template', () {
    test('applies mustache templates', () async {
      // Create the template
      var templateContents = '<div id="content">{{{content}}}</div>';
      var templateId = new AssetId('a', 'web/templates/mytemplate.html');

      // Create the page
      var fileContents = '<p>hello</p>';
      var fileId = new AssetId('a', 'web/mypage.html');

      var metadataContents = JSON.encode({'template': 'mytemplate'});
      var metadataId = new AssetId('a', 'web/mypage.metadata.json');

      var assets = {
        templateId: templateContents,
        fileId: fileContents,
        metadataId: metadataContents,
      };

      // Run barback
      var t = new TestCase([new Template(), new TemplateCleanup()], assets);
      var barback = await t.run();

      // Verify the template was not outputted
      var allAssets = await barback.getAllAssets();
      expect(allAssets, hasLength(2));

      // Check the output file contents
      var id = new AssetId('a', 'web/mypage.html');
      var asset = await barback.getAssetById(id);
      var contents = await asset.readAsString();
      expect(contents, contains('<div id="content"><p>hello</p></div>'));
    });
  });

  group('tag metadata', () {
    test('is added to page metadata', () async {
      // Create two pages
      var metadata1Contents = JSON.encode({
        'tags': ['foo']
      });
      var metadata2Contents = JSON.encode({
        'tags': ['bar']
      });

      var metadata1Id = new AssetId('a', 'web/mypage1.metadata.json');
      var metadata2Id = new AssetId('a', 'web/mypage2.metadata.json');

      var assets = {
        metadata1Id: metadata1Contents,
        metadata2Id: metadata2Contents,
      };

      var settings = new TavernSettings();

      // Run barback
      var t = new TestCase([new TagMetadata(settings)], assets);
      var barback = await t.run();

      // Check the output file contents
      var id1 = new AssetId('a', 'web/mypage1.metadata.json');
      var asset1 = await barback.getAssetById(id1);
      var contents1 = await asset1.readAsString();
      var decoded1 = JSON.decode(contents1) as Map<String, dynamic>;

      var id2 = new AssetId('a', 'web/mypage2.metadata.json');
      var asset2 = await barback.getAssetById(id2);
      var contents2 = await asset2.readAsString();
      var decoded2 = JSON.decode(contents2) as Map<String, dynamic>;

      expect(decoded1.containsKey('tag_metadata'), isTrue);
      expect(decoded2.containsKey('tag_metadata'), isTrue);
      var expected = [
        {"name": "foo", "url": "/tags/foo.html"},
        {"name": "bar", "url": "/tags/bar.html"}
      ];
      const mapEqual = const DeepCollectionEquality.unordered();
      expect(mapEqual.equals(decoded1['tag_metadata'], expected), isTrue);
      expect(mapEqual.equals(decoded2['tag_metadata'], expected), isTrue);
    });
  });

  group('TagPages', () {
    test('skips if no tags are provided', () async {
      // Create a page
      var metadataContents = JSON.encode({});
      var metadataId = new AssetId('a', 'web/mypage.metadata.json');

      var assets = {
        metadataId: metadataContents,
      };

      var settings = new TavernSettings();

      // Run barback
      var t = new TestCase([new TagPages(settings)], assets);
      var barback = await t.run();

      // Check the output file contents
      var outputAssets = await barback.getAllAssets();
      expect(outputAssets, hasLength(1));
    });

    test('skips if no tag_index template is provided', () async {
      // Create a page
      var metadataContents = JSON.encode({
        'tags': ['foo', 'bar']
      });
      var metadataId = new AssetId('a', 'web/mypage.metadata.json');

      var assets = {
        metadataId: metadataContents,
      };

      var settings = new TavernSettings();

      // Run barback
      var t = new TestCase([new TagPages(settings)], assets);
      var barback = await t.run();

      // Check the output file contents
      var outputAssets = await barback.getAllAssets();
      expect(outputAssets, hasLength(1));
    });

    test('generates tag pages', () async {
      // Create a page
      var metadataContents = JSON.encode({
        'tags': ['foo', 'bar'],
        'url': '/mypage.html'
      });
      var metadataId = new AssetId('a', 'web/mypage.metadata.json');

      var tagIndexContents = '<div>'
          '{{#tags}}'
          '<li><a href="{{url}}">{{name}}</a></li>'
          '{{/tags}}'
          '</div>';

      var tagIndexId = new AssetId('a', 'web/templates/tag_index.html');

      var tagPageContents = '<h1>Posts Tagged {{tag}}</h1>'
          '<div id="content">'
          '<ul>'
          '{{#posts}}'
          '<li><a href="{{url}}">{{name}}</a></li>'
          '{{/posts}}'
          '</ul>'
          '</div>';

      var tagPageId = new AssetId('a', 'web/templates/tag_page.html');

      var assets = {
        metadataId: metadataContents,
        tagIndexId: tagIndexContents,
        tagPageId: tagPageContents,
      };

      var settings = new TavernSettings(
          siteUrl: 'http://foo.com', sitemapPath: '/sitemap.xml');

      // Run barback
      var t = new TestCase([new TagPages(settings)], assets);
      var barback = await t.run();

      // Check the output file contents
      var outputAssets = await barback.getAllAssets();
      expect(outputAssets, hasLength(5));

      // Verify the tag page was created.
      var tagPage = outputAssets
          .firstWhere((asset) => asset.id.path == "web/tags/foo.html");
      var expected = '<h1>Posts Tagged foo</h1>'
          '<div id="content">'
          '<ul><li><a href="&#x2F;mypage.html"></a></li></ul>'
          '</div>';
      expect(await tagPage.readAsString(), equals(expected));
      expect(tagPage, isNotNull);
    });
  });

  group('Sitemap', () {
    test('generates sitemap.xml based on settings', () async {
      // Create a page
      var indexContents = '''<html></html>''';
      var indexId = new AssetId('a', 'web/index.html');

      var assets = {
        indexId: indexContents,
      };

      var settings = new TavernSettings(
          siteUrl: 'http://foo.com', sitemapPath: 'sitemap.xml');

      // Run barback
      var t = new TestCase([new Sitemap(settings)], assets);
      var barback = await t.run();

      // Check the output file contents
      var id = new AssetId('a', 'web/sitemap.xml');
      var asset = await barback.getAssetById(id);
      var contents = await asset.readAsString();
      expect(contents, isNotEmpty);

      // Load expected file contents
      var path = 'test/fixtures/sitemap.xml';
      var file = new File(path);
      var expected = file.readAsStringSync();

      expect(contents, equals(expected));
    });
  });

  group('TagPageUrlGenerator', () {
    test('stripIndexHtml: false', () {
      var generator = new TagPageUrlGenerator('/tags/{{tag}}.html');
      var result = generator.getUrl('hello');
      expect(result, equals('/tags/hello.html'));
    });
    test('stripIndexHtml: true', () {
      var generator = new TagPageUrlGenerator('/tags/{{tag}}.html');
      var result = generator.getUrl('index', stripIndexHtml: true);
      expect(result, equals('/tags/'));
    });
    test('stripIndexHtml: true with no index', () {
      var generator = new TagPageUrlGenerator('/tags/{{tag}}.html');
      var result = generator.getUrl('hello', stripIndexHtml: true);
      expect(result, equals('/tags/hello.html'));
    });
  });
}

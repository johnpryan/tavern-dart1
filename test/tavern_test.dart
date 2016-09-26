import 'dart:convert';
import 'dart:io';
import 'package:tavern/src/settings.dart';
import 'package:tavern/src/sitemap.dart';
import 'package:tavern/src/tag_index.dart';
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

  group('tag index', () {
    test('renders a tag index using a tag_index.html template', () async {
      // Create a page
      var metadataContents = JSON.encode({
        'tags': ['foo', 'bar']
      });
      var metadataId = new AssetId('a', 'web/mypage.metadata.json');

      var tagIndexContents = '<div>'
          '{{#tags}}'
          '<li><a href="{{url}}">{{name}}</a></li>'
          '{{/tags}}'
          '</div>';

      var tagIndexId = new AssetId('a', 'web/templates/tag_index.html');

      var assets = {
        metadataId: metadataContents,
        tagIndexId: tagIndexContents,
      };

      // Run barback
      var t = new TestCase([new TagIndex()], assets);
      var barback = await t.run();

      // Check the output file contents
      var id = new AssetId('a', 'web/tags/index.html');
      var asset = await barback.getAssetById(id);
      var contents = await asset.readAsString();
      var expected = '<li><a href="/tags/foo.html">foo</a></li>';
      expect(contents, contains(expected));
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

      // Run barback
      var t = new TestCase([new TagIndex()], assets);
      var barback = await t.run();

      // Check the output file contents
      var outputAssets = await barback.getAllAssets();
      expect(outputAssets, hasLength(1));
    });
  });

  group('TagPages', () {
      test('skips if no tag_index template is provided', () async {
        // Create a page
        var metadataContents = JSON.encode({
          'tags': ['foo', 'bar']
        });
        var metadataId = new AssetId('a', 'web/mypage.metadata.json');

        var assets = {
          metadataId: metadataContents,
        };

        // Run barback
        var t = new TestCase([new TagPages()], assets);
        var barback = await t.run();

        // Check the output file contents
        var outputAssets = await barback.getAllAssets();
        expect(outputAssets, hasLength(1));
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

      var settings = new TavernSettings('http://foo.com', 'sitemap.xml');

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
}

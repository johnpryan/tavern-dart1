import 'dart:convert';
import 'dart:io';
import 'package:tavern/src/template.dart';
import 'package:test/test.dart';
import 'package:barback/barback.dart';
import 'package:tavern/src/contents.dart';
import 'package:tavern/src/metadata.dart';
import 'utils/test_case.dart';

main() {
  group('contents transformer', () {
    test('moves code from contents to root directory', () async {
      var contents = "hello world";
      var assets = {new AssetId('a', 'web/contents/foo.txt'): contents};
      var expected = {new AssetId('a', 'web/foo.txt'): contents};
      var t = new TestCase([new Contents()], assets);
      await t.runAndCheck(expected);
    });
  });

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
      var t = new TestCase([new Template()], assets);
      var barback = await t.run();

      // Check the output file contents
      var id = new AssetId('a', 'web/mypage.html');
      var asset = await barback.getAssetById(id);
      var contents = await asset.readAsString();
      expect(contents, contains('<div id="content"><p>hello</p></div>'));
    });
  });
}

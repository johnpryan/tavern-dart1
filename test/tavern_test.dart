import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';
import 'package:barback/barback.dart';
import 'package:tavern/src/contents.dart';
import 'package:tavern/src/metadata.dart';
import 'utils/test_case.dart';

main() {
  group('contents transformer', () {
    test('moves code from contents to root directory', () async {
      var contents = "hello world";
      var input = {new AssetId('a', 'web/contents/foo.txt'): contents};
      var expected = {new AssetId('a', 'web/foo.txt'): contents};
      var t = new TestCase([new Contents()], input);
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
      var input = {new AssetId('a', 'web/foo.md'): contents};

      // Run barback
      var t = new TestCase([new Metadata()], input);
      var barback = await t.run();

      // Check the metadata file contents
      var id = new AssetId('a', 'web/foo.metadata.json');
      var asset = await barback.getAssetById(id);
      var json = JSON.decode(await asset.readAsString());
      expect(json, containsPair('foo', 'bar'));
    });
  });
}

import 'package:test/test.dart';
import 'package:tavern/src/metadata.dart';
import 'dart:io';

main() {
  group('extract metadata', () {
    test('extracts metadata', () {
      var file = new File('test/fixtures/metadata.md');
      var contents = file.readAsStringSync();
      var result = extractMetadata(contents);
      expect(result.metadata, isNotNull);
      expect(result.content, isNotNull);
      expect(result.metadata.keys, contains('foo'));
      expect(result.content, startsWith('# header'));
    });
    test('returns null if no metadata', () {
      var file = new File('test/fixtures/no_metadata.md');
      var contents = file.readAsStringSync();
      var result = extractMetadata(contents);
      expect(result, isNull);
    });

    test('throws if bad metadata', () {
      var file = new File('test/fixtures/bad_metadata.md');
      var contents = file.readAsStringSync();
      expect(() => extractMetadata(contents), throws);
    });

    test('generateMetadataPath', () {
      var input = 'test/fixtures/foo.md';
      var expected = 'test/fixtures/foo.metadata.json';
      expect(generateMetadataPath(input), expected);
    });
  });
}
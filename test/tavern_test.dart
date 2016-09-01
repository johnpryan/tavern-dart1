import 'package:test/test.dart';
import 'package:barback/barback.dart';
import 'package:tavern/src/contents.dart';
import 'utils/test_case.dart';

main() {
  group('contents transformer', () {
    test('moves code from contents to root directory', () async {
      var contents = "hello world";
      var input = {new AssetId('a', 'web/contents/foo.txt'): contents};
      var expected = {new AssetId('a', 'web/foo.txt'): contents};
      var t = new TestCase([new Contents()], input, expected);
      await t.run();
    });
  });
}

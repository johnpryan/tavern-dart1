library tavern.utils;

import 'package:path/path.dart' as path;

String getMetadataPath(String p) {
  var dirname = path.dirname(p);
  var basename = path.basenameWithoutExtension(p);
  var filename = basename + '.metadata.json';
  return path.join(dirname, filename);
}
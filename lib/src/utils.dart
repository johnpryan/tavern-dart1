library tavern.utils;

import 'package:path/path.dart' as path;

const String metadataExtension = '.metadata.json';
const String templatesPath = 'web/templates/';

String getMetadataPath(String p) {
  var dirname = path.dirname(p);
  var basename = path.basenameWithoutExtension(p);
  var filename = basename + metadataExtension;
  return path.join(dirname, filename);
}
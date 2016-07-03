library tavern.cleanup;

import 'dart:async';

import 'package:barback/barback.dart';
import 'package:path/path.dart' as path;
import 'package:tavern/src/utils.dart';

class Cleanup extends Transformer {
  Cleanup();

  Future apply(Transform transform) async => transform.consumePrimary();

  Future<bool> isPrimary(AssetId id) async {
    var isTemplate = id.path.startsWith(templatesPath) && id.extension == '.html';
    var isMetadata = path.basename(id.path).endsWith(metadataExtension);
    print('isMetadata(${id.path}) = $isMetadata');
    return isTemplate || isMetadata;
  }
}

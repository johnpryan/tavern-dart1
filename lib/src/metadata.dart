library tavern.metadata;

import 'package:barback/barback.dart';
import 'dart:async';

class MetadataTransformer extends Transformer {
  MetadataTransformer.asPlugin();

  Future<bool> isPrimary(AssetId id) async =>
    id.path.startsWith('web/contents/');

  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var package = transform.primaryInput.id.package;
    var inputPath = transform.primaryInput.id.path;

    var newPath = inputPath.replaceFirst('contents/', '');
    var newId = new AssetId(package, newPath);
    var newAsset = new Asset.fromString(newId, content);
    transform.addOutput(newAsset);
  }
}
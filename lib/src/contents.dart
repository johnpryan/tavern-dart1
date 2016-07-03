library tavern.metadata;

import 'package:barback/barback.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

class ContentsTransformer extends Transformer {
  ContentsTransformer.asPlugin();

  Future<bool> isPrimary(AssetId id) async =>
    id.path.startsWith('web/contents/');

  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var package = transform.primaryInput.id.package;
    var inputPath = transform.primaryInput.id.path;

    var components = path.split(inputPath);
    components.remove(components.firstWhere((s) => s == 'contents'));
    var newPath = path.joinAll(components);

    var newId = new AssetId(package, newPath);
    var newAsset = new Asset.fromString(newId, content);
    transform.addOutput(newAsset);
  }
}
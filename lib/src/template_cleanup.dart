library tavern.template_cleanup;

import 'dart:async';

import 'package:barback/barback.dart';
import 'package:tavern/src/utils.dart';

class TemplateCleanup extends Transformer {
  TemplateCleanup();

  Future apply(Transform transform) async {
    transform.consumePrimary();
  }

  Future<bool> isPrimary(AssetId id) async {
    var isTemplate = id.path.startsWith(templatesPath);
    return isTemplate;
  }
}

library tavern.markdown;

import 'dart:async';

import 'package:barback/barback.dart';
import 'package:markdown/markdown.dart';

class Markdown extends Transformer {
  Markdown();
  String get allowedExtensions => ".md .markdown .mdown";
  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var id = transform.primaryInput.id.changeExtension(".html");
    var newContent = markdownToHtml(content);
    transform.consumePrimary();
    transform.addOutput(new Asset.fromString(id, newContent));
  }
}
library tavern.markdown;

import 'package:barback/barback.dart';
import 'package:markdown/markdown.dart';

import 'dart:async';

class Markdown extends Transformer {
  Markdown();

  // Any markdown file with one of the following extensions is
  // converted to HTML.
  String get allowedExtensions => ".md .markdown .mdown";

  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();

    // The extension of the output is changed to ".html".
    var id = transform.primaryInput.id.changeExtension(".html");

    var newContent =
        "<html><body>" + markdownToHtml(content) + "</body></html>";

    transform.consumePrimary();
    transform.addOutput(new Asset.fromString(id, newContent));
  }
}
import 'package:barback/barback.dart';
import 'package:tavern/src/utils.dart';
import 'dart:convert';
import 'dart:async';
import 'package:mustache/mustache.dart' as mustache;

const templateFilePath = "web/templates/tag_index.html";
const tagPath = "/tags";

class TagIndex extends AggregateTransformer {
  @override
  Future apply(AggregateTransform transform) async {
    // Use a set to dedupe tags found in metadata files
    var tags = new Set();

    // load all metadata.json files
    await for (var input in transform.primaryInputs) {
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      tags.addAll(contentMap['tags'] ?? []);
    }

    // Fail gracefully if there is no tag_index.html template
    var templateId = new AssetId(transform.package, templateFilePath);
    if (!(await transform.hasInput(templateId))) {
      return;
    }

    // Load the template
    var templateAsset = await transform.getInput(templateId);
    var templateContents = await templateAsset.readAsString();

    // Generate metadata to feed into the mustache template
    var metadata = {};
    metadata['tags'] = [];
    for (var tag in tags) {
      metadata['tags'].add({'name': tag, 'url': "$tagPath/$tag.html"});
    }

    // Render the mustache template.  The mustache library escapes html
    // differently from dart:convert's HtmlEscape converter so it is not used.
    var template =
        new mustache.Template(templateContents, htmlEscapeValues: false);
    var output = template.renderString(metadata);

    // Output the HTML page
    var id = new AssetId(transform.package, "web/tags/index.html");
    transform.addOutput(new Asset.fromString(id, output));
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

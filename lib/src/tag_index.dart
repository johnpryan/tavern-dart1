import 'package:barback/barback.dart';
import 'package:tavern/src/utils.dart';
import 'dart:convert';
import 'dart:async';
import 'package:mustache/mustache.dart' as mustache;


const outputFilePath = "web/tags/index.html";
const templateFilePath = "web/templates/tag_index.html";
const tagPath = "/tags";

class TagIndex extends AggregateTransformer {

  @override
  Future apply(AggregateTransform transform) async {
    var tags = new Set();
    await for (var input in transform. primaryInputs) {
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      tags.addAll(contentMap['tags'] ?? []);
    }
    var id = new AssetId(transform.package, outputFilePath);
    var templateId = new AssetId(transform.package, templateFilePath);
    var templateAsset = await transform.getInput(templateId);
    var templateContents = await templateAsset.readAsString();

    var metadata = {};
    metadata['tags'] = [];
    for (var tag in tags) {
      metadata['tags'].add({
        'name': tag,
        'url': '$tagPath/$tag.html'
      });
    }

    var template = new mustache.Template(templateContents);
    var output = template.renderString(metadata);

    transform.addOutput(new Asset.fromString(id, output));
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}
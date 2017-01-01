import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';

import 'package:tavern/src/settings.dart';
import 'package:tavern/src/tag_pages.dart';
import 'package:tavern/src/utils.dart';

const templateFilePath = "web/templates/tag_index.html";

class TagMetadata extends AggregateTransformer {
  final TavernSettings settings;
  final TagPageUrlGenerator _tagPageUrlGenerator;

  TagMetadata(TavernSettings settings)
      : this.settings = settings,
        _tagPageUrlGenerator = new TagPageUrlGenerator(settings.tagPagePath);

  @override
  Future apply(AggregateTransform transform) async {
    // All the files that have been read
    Map<AssetId, Map<String, dynamic>> metadata = {};

    // All (unique) tags that were found
    var tags = new Set<String>();

    // load all metadata.json files
    await for (var input in transform.primaryInputs) {
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      metadata[input.id] = contentMap;
      tags.addAll(contentMap['tags'] ?? []);
    }

    // Create tag metadata to add
    var generateUrl =
        (String tag) => _tagPageUrlGenerator.getUrl(tag, stripIndexHtml: true);
    var tagMetadata =
        tags.map((tag) => {'name': tag, 'url': generateUrl(tag)}).toList();

    // write tag_metadata to each metadata file
    for (var id in metadata.keys) {
      var output = metadata[id]..addAll({"tag_metadata": tagMetadata});
      var outputString = JSON.encode(output);
      transform.addOutput(new Asset.fromString(id, outputString));
    }
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

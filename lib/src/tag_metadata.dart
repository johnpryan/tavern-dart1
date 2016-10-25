import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';

import 'package:tavern/src/models.dart';
import 'package:tavern/src/settings.dart';
import 'package:tavern/src/tag_pages.dart';
import 'package:tavern/src/utils.dart';

class TagMetadata extends AggregateTransformer {
  final TavernSettings settings;
  TagPageUrlGenerator _tagPageUrlGenerator;

  TagMetadata(this.settings) {
    _tagPageUrlGenerator = new TagPageUrlGenerator(settings.tagPagePath);
  }

  @override
  Future apply(AggregateTransform transform) async {
    // Use a set to dedupe tags found in metadata files
    var tags = new Set<Tag>();

    var primaryInputs = await transform.primaryInputs.toList();
    // load all metadata.json files
    for (var input in primaryInputs) {
      var content = await input.readAsString();
      var metadata = new Metadata.fromJson(JSON.decode(content));
      tags.addAll(metadata.tags
              .map((String t) => new Tag(
                  t, _tagPageUrlGenerator.getUrl(t, stripIndexHtml: true)))
              .toList() ??
          []);
    }

    // now that all of the tags have been loaded, write them all back to the
    // metadata files
    for (var input in primaryInputs) {
      var content = await input.readAsString();
      var metadata = new Metadata.fromJson(JSON.decode(content));
      metadata.allTags = tags.toList();
      var output = JSON.encode(metadata.toJson());
      var asset = new Asset.fromString(input.id, output);
      transform.addOutput(asset);
    }
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

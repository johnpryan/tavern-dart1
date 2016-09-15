library tavern.metadata_aggregator;

import 'utils.dart';
import 'dart:async';
import 'package:barback/barback.dart';
import 'dart:convert';
import 'package:tavern/src/models.dart';

const aggregateFilePath = "web/aggregate.tavern.json";

class MetadataAggregator extends AggregateTransformer {
  MetadataAggregator();
  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }

  Future apply(AggregateTransform transform) async {
    var aggregate = {};
    await for (var input in transform.primaryInputs) {
      var tags = aggregate['tags'] ?? [];
      var tagSet = new Set<String>()..addAll(tags);
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      tagSet.addAll(contentMap['tags'] ?? []);
      aggregate['tags'] = tagSet.toList();
    }

    var id = new AssetId(transform.package, aggregateFilePath);
    var aggregateContent = JSON.encode(aggregate);
    transform.addOutput(new Asset.fromString(id, aggregateContent));
  }
}
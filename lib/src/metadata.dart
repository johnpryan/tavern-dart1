library tavern.metadata;

import 'package:barback/barback.dart';
import 'package:yaml/yaml.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tavern/src/utils.dart';

class Metadata extends Transformer {
  Metadata();
  String get allowedExtensions => ".md .markdown .mdown";

  Future apply(Transform transform) async {
    var id = transform.primaryInput.id;
    var content = await transform.primaryInput.readAsString();

    var metadata = extractMetadata(content, transform.primaryInput.id.path);
    if (metadata == null) {
      transform.addOutput(new Asset.fromString(id, content));
      return;
    }

    transform.consumePrimary();
    var output = new Asset.fromString(id, metadata.content);
    transform.addOutput(output);

    var package = transform.primaryInput.id.package;
    var metadataPath = getMetadataPath(transform.primaryInput.id.path);
    var metadataId = new AssetId(package, metadataPath);
    var json = JSON.encode(metadata.metadata);
    transform.addOutput(new Asset.fromString(metadataId, json));
  }
}

MetadataOutput extractMetadata(String file, String path) {
  const separator = '---';
  var lines = file.split('\n');
  if (!lines.first.startsWith(separator)) return null;
  int first;
  int last;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].startsWith(separator)) {
      if (first == null) {
        first = i;
        continue;
      }
      last = i;
      continue;
    }
  }
  if (first == null || last == null) return null;
  var yamlStr = lines.getRange(first + 1, last).join('\n');
  var yaml = loadYaml(yamlStr);
  if (yaml is! Map) {
    throw ('unexpected metadata');
  }

  var metadata = new Map.from(yaml);
  metadata['url'] = getHtmlPath(path);

  lines.removeRange(first, last + 1);
  return new MetadataOutput(metadata, lines.join('\n'));
}

class MetadataOutput {
  final Map<String, dynamic> metadata;
  final String content;
  MetadataOutput(this.metadata, this.content);
}
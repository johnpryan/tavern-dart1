library tavern.metadata;

import 'package:barback/barback.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:convert';

class Metadata extends Transformer {
  Metadata();
  String get allowedExtensions => ".md .markdown .mdown";

  Future apply(Transform transform) async {
    var id = transform.primaryInput.id;
    var content = await transform.primaryInput.readAsString();

    var metadata = extractMetadata(content);
    if (metadata == null) {
      transform.addOutput(new Asset.fromString(id, content));
      return;
    }

    transform.consumePrimary();
    var output = new Asset.fromString(id, metadata.content);
    transform.addOutput(output);

    var package = transform.primaryInput.id.package;
    var metadataPath = generateMetadataPath(transform.primaryInput.id.path);
    var metadataId = new AssetId(package, metadataPath);
    var json = JSON.encode(metadata.metadata);
    transform.addOutput(new Asset.fromString(metadataId, json));
  }
}

MetadataOutput extractMetadata(String file) {
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

  lines.removeRange(first, last + 1);
  return new MetadataOutput(yaml, lines.join('\n'));
}

String generateMetadataPath(String p) {
  var dirname = path.dirname(p);
  var basename = path.basenameWithoutExtension(p);
  var filename = basename + '.metadata.json';
  return path.join(dirname, filename);
}

class MetadataOutput {
  final Map<String, dynamic> metadata;
  final String content;
  MetadataOutput(this.metadata, this.content);
}
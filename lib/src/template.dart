library tavern.template;

import 'package:barback/barback.dart';
import 'package:mustache/mustache.dart' as mustache;
import 'package:path/path.dart' as path;

import 'dart:async';
import 'package:tavern/src/utils.dart';
import 'dart:io';
import 'dart:convert';

class Template extends Transformer {
  Template();

  Future<bool> isPrimary(AssetId id) async {
    var isTemplate = id.path.startsWith('web/templates/');
    var isHtml = id.extension == '.html';
    return isHtml && !isTemplate;
  }

  Future apply(Transform transform) async {
    var content = await transform.primaryInput.readAsString();
    var id = transform.primaryInput.id;

    var filePath = transform.primaryInput.id.path;
    var metadataPath = getMetadataPath(filePath);
    var package = transform.primaryInput.id.package;
    var metadataId = new AssetId(package, metadataPath);
    var metadataAsset = await transform.getInput(metadataId);
    var metadata = JSON.decode(await metadataAsset.readAsString());

    // add this file's content to the metadata map
    metadata['content'] = content;
    print('content = $content');

    // get the associated template
    var templateName = metadata['template'];
    var templatePath = 'web/templates/' + templateName + '.html';
    var templateId = new AssetId(package, templatePath);
    var templateAsset = await transform.getInput(templateId);
    var templateContents = await templateAsset.readAsString();

    var template = new mustache.Template(templateContents);
    var output = template.renderString(metadata);

    transform.consumePrimary();
    transform.addOutput(new Asset.fromString(id, output));
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';
import 'package:mustache/mustache.dart' as mustache;

import 'package:tavern/src/models.dart';
import 'package:tavern/src/settings.dart';
import 'package:tavern/src/utils.dart';

const templateFilePath = "web/templates/tag_page.html";

class TagPageUrlGenerator {
  static const indexFile = 'index.html';

  final mustache.Template _template;

  TagPageUrlGenerator(String path) :
    _template = new mustache.Template(path) {
  }

  String getUrl(String tag, {bool stripIndexHtml: false}) {
    String url = _template.renderString({'tag': tag});
    if (stripIndexHtml && url.endsWith('/$indexFile'))
      url = url.substring(0, url.length - indexFile.length);
    return url;
  }
}

class TagPages extends AggregateTransformer {
  final TavernSettings settings;
  TagPageUrlGenerator _tagPageUrlGenerator;

  TagPages(this.settings) {
    _tagPageUrlGenerator = new TagPageUrlGenerator(settings.tagPagePath);
  }

  @override
  Future apply(AggregateTransform transform) async {
    Map<String, List<Post>> tagToPostsLookup = {};

    await for (var input in transform.primaryInputs) {
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      for (var tag in contentMap['tags'] ?? []) {
        tagToPostsLookup[tag] ??= [];
        var post = new Post(contentMap['title'], contentMap['url'] ?? '#');
        tagToPostsLookup[tag].add(post);
      }
    }

    // Fail gracefully if the template is not provided.
    var templateId = new AssetId(transform.package, templateFilePath);
    var hasTemplateAsset = await transform.hasInput(templateId);
    if (!hasTemplateAsset) return;

    for (var tag in tagToPostsLookup.keys) {
      var path = 'web${_tagPageUrlGenerator.getUrl(tag)}';
      var id = new AssetId(transform.package, path);

      var templateAsset = await transform.getInput(templateId);
      var templateContents = await templateAsset.readAsString();
      var posts = tagToPostsLookup[tag].map((post) => post.toJson()).toList();
      var templateData = {'tag': tag, 'posts': posts};
      var template = new mustache.Template(templateContents);
      var output = template.renderString(templateData);
      var asset = new Asset.fromString(id, output);
      transform.addOutput(asset);
    }
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

import 'package:barback/barback.dart';
import 'dart:async';
import 'package:tavern/src/utils.dart';
import 'dart:convert';
import 'package:mustache/mustache.dart' as mustache;

const templateFilePath = "web/templates/tag_page.html";

class TagPages extends AggregateTransformer {
  @override
  Future apply(AggregateTransform transform) async {

    Map<String, Set<Post>> tagToPostsLookup = {};

    await for (var input in transform.primaryInputs) {
      var content = await input.readAsString();
      var contentMap = JSON.decode(content);
      for (var tag in contentMap['tags']) {
        if (tagToPostsLookup[tag] == null) {
          tagToPostsLookup[tag] = new Set();
        }
        var post = new Post(contentMap['title'], contentMap['url'] ?? '#');
        tagToPostsLookup[tag].add(post);
      }
    }

    for (var tag in tagToPostsLookup.keys) {
      var path = 'web/tags/$tag.html';
      var id = new AssetId(transform.package, path);
      var templateId = new AssetId(transform.package, templateFilePath);
      var templateAsset = await transform.getInput(templateId);
      var templateContents = await templateAsset.readAsString();
      var templateData = {
        'tag': tag,
        'posts': []
      };
      for (var post in tagToPostsLookup[tag]) {
        templateData['posts'].add({
          'name': post.name,
          'url': post.url,
        });
      }
      var template = new mustache.Template(templateContents);
      var output = template.renderString(templateData);
      transform.addOutput(new Asset.fromString(id, output));
    }
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

class Post {
  String name;
  String url;
  Post(this.name, this.url);
}
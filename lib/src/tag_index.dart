import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';
import 'package:mustache/mustache.dart' as mustache;

import 'package:tavern/src/settings.dart';
import 'package:tavern/src/tag_pages.dart';
import 'package:tavern/src/utils.dart';

const templateFilePath = "web/templates/tag_index.html";

class TagIndex extends AggregateTransformer {
  final TavernSettings settings;
  final TagPageUrlGenerator _tagPageUrlGenerator;

  TagIndex(TavernSettings settings)
      : this.settings = settings,
        _tagPageUrlGenerator = new TagPageUrlGenerator(settings.tagPagePath);

  @override
  Future apply(AggregateTransform transform) async {
    // Fail gracefully if there is no tag_index.html template
    var templateId = new AssetId(transform.package, templateFilePath);
    if (!(await transform.hasInput(templateId))) {
      return;
    }

    // Load the template
    var templateAsset = await transform.getInput(templateId);
    var templateContents = await templateAsset.readAsString();

    // Generate metadata to feed into the mustache template
    var generateUrl =
        (String tag) => _tagPageUrlGenerator.getUrl(tag, stripIndexHtml: true);
    var metadata = {
      'tags': tags.map((tag) => {'name': tag, 'url': generateUrl(tag)}).toList()
    };

    // Render the mustache template.  The mustache library escapes html
    // differently from dart:convert's HtmlEscape converter so it is not used.
    var template =
        new mustache.Template(templateContents, htmlEscapeValues: false);
    var output = template.renderString(metadata);

    // Output the HTML page
    var id = new AssetId(transform.package, 'web${settings.tagPageIndex}');
    transform.addOutput(new Asset.fromString(id, output));
  }

  @override
  classifyPrimary(AssetId id) {
    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}

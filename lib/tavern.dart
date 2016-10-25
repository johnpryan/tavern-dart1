library tavern;

import 'package:barback/barback.dart';

import 'package:tavern/src/cleanup.dart';
import 'package:tavern/src/markdown.dart';
import 'package:tavern/src/metadata.dart';
import 'package:tavern/src/metadata_aggregator.dart';
import 'package:tavern/src/settings.dart';
import 'package:tavern/src/sitemap.dart';
import 'package:tavern/src/tag_index.dart';
import 'package:tavern/src/tag_pages.dart';
import 'package:tavern/src/template.dart';
import 'package:tavern/src/template_cleanup.dart';

class Tavern implements TransformerGroup {
  @override
  Iterable<Iterable> phases;

  Tavern.asPlugin(BarbackSettings settings) {
    phases = createPhases(settings);
  }
}

List<List<Transformer>> createPhases(BarbackSettings barbackSettings) {
  var settings = new TavernSettings.fromJson(barbackSettings.configuration);
  return [
    [new MetadataTransformer()],
    [new TagIndex(settings)],
    [new MetadataAggregator()],
    [new Markdown()],
    [new Template()],
    [new TagPages(settings)],
    [new TemplateCleanup()],
    [new Sitemap(settings)],
    [new Cleanup()],
  ];
}

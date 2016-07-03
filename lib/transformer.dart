library tavern;

import 'package:barback/barback.dart';

import 'package:tavern/src/contents.dart';
import 'package:tavern/src/markdown.dart';
import 'package:tavern/src/metadata.dart';

class Tavern implements TransformerGroup {
  final Iterable<Iterable> phases;
  Tavern() : phases = createPhases();
  Tavern.asPlugin(settings) : this();
}

List<List<Transformer>> createPhases() {
  return [
    [new Metadata()],
    [new Contents()],
    [new Markdown()],
  ];
}

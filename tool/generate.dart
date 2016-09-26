library tavern.generate;

import 'package:build/build.dart';

import 'package:source_gen/generators/json_literal_generator.dart' as literal;
import 'package:source_gen/generators/json_serializable_generator.dart' as json;
import 'package:source_gen/source_gen.dart';

main() async {
  await build(phases, deleteFilesByDefault: true);
}

final PhaseGroup phases = new PhaseGroup.singleAction(
    new GeneratorBuilder(const [
      const json.JsonSerializableGenerator(),
      const literal.JsonLiteralGenerator()
    ]),
    new InputSet('tavern', const ['lib/src/settings.dart']));

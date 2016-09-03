import 'dart:async';

import 'package:barback/barback.dart';
import 'package:test/test.dart';

import 'in_memory_package_provider.dart';

class TestCase {
  final List<Transformer> transformers;
  final Map<AssetId, String> input;
  InMemoryPackageProvider packageProvider = new InMemoryPackageProvider();
  TestCase(this.transformers, this.input);
  Future runAndCheck(Map<AssetId, String> expected) async {
    var barback = await run();

    var assets = (await barback.getAllAssets()).toList();
    expect(assets, hasLength(expected.keys.length));

    // Check results
    for (var expectedId in expected.keys) {
      var expectedContents = expected[expectedId];
      var result = await barback.getAssetById(expectedId);

      // Check the path and the contents
      expect(result.id.path, expectedId.path);
      expect(await result.readAsString(), expectedContents);
    }
  }

  Future<Barback> run() async {
    // add input files
    for (var key in input.keys) {
      packageProvider.add(key, input[key]);
    }

    // Create a Set of all packages included in the input asset ids
    var packages = input.keys.map((k) => k.package).toSet();

    // Create Barback
    var barback = new Barback(packageProvider);

    // Ensure the Transformers run on each package
    for (var package in packages) {
      barback.updateTransformers(package, [transformers]);
    }

    // Throw any errors
    barback.results.listen((BuildResult r) {
      if (r.errors.isEmpty) return;
      throw(r);
    });

    // Run Barback
    barback.updateSources(input.keys);
    return barback;
  }
}

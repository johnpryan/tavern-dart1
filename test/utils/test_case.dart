import 'dart:async';

import 'package:barback/barback.dart';
import 'package:test/test.dart';

import 'in_memory_package_provider.dart';

class TestCase {
  final List<Transformer> transformers;
  final Map<AssetId, String> input;
  final Map<AssetId, String> expected;
  InMemoryPackageProvider packageProvider = new InMemoryPackageProvider();
  TestCase(this.transformers, this.input, this.expected);
  Future run() async {
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

    // Run Barback
    barback.updateSources(input.keys);

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
}
import 'dart:async';
import 'package:barback/src/asset/asset.dart';
import 'package:barback/src/asset/asset_id.dart';
import 'package:barback/src/package_provider.dart';

class InMemoryPackageProvider implements PackageProvider {
  Map<AssetId, String> _assets = {};

  Future<Asset> getAsset(AssetId id) async {
    var contents = _assets[id];
    return new Asset.fromString(id, contents);
  }

  Iterable<String> get packages => ['a'];

  void add(AssetId id, String contents) {
    _assets[id] = contents;
  }
}
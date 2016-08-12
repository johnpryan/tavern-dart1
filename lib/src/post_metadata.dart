library tavern.post_metadata;
import 'package:barback/barback.dart';

/// adds absolute path to each post's metadata
class PostMetadata extends AggregateTransformer {

  apply(AggregateTransform transform) {
  }

  classifyPrimary(AssetId id) {
//    return id.path.endsWith(metadataExtension) ? 'meta' : null;
  }
}
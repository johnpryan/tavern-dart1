library tavern.models;

import 'package:source_gen/generators/json_serializable.dart';
import 'package:quiver/core.dart';

part 'models.g.dart';

@JsonSerializable()
class Post extends _$PostSerializerMixin {
  String name;
  String url;
  Post(this.name, this.url);
  factory Post.fromJson(json) => _$PostFromJson(json);
}

@JsonSerializable()
class Metadata extends _$MetadataSerializerMixin {
  final String title;
  final String template;
  final String category;
  final List<String> tags;
  String url;
  @JsonKey('all_tags')
  List<Tag> allTags;
  Metadata(this.title, this.template, this.category, this.tags, [this.url, this.allTags]);
  factory Metadata.fromJson(json) => _$MetadataFromJson(json);
}

@JsonSerializable()
class Tag extends _$TagSerializerMixin {
  final String name;
  final String url;
  Tag(this.name, this.url);
  operator ==(Tag other) {
    return this.name == other.name && this.url == other.url;
  }
  int get hashCode => hash2(name, url);

  factory Tag.fromJson(json) => _$TagFromJson(json);
}
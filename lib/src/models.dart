library tavern.models;

import 'package:source_gen/generators/json_serializable.dart';

part 'models.g.dart';

class Tag {
  String name;
  String link;
  Tag(this.name);
}

@JsonSerializable()
class Post extends _$PostSerializerMixin {
  String name;
  String url;
  Post(this.name, this.url);
  factory Post.fromJson(json) => _$PostFromJson(json);
}

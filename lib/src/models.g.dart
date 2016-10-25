// GENERATED CODE - DO NOT MODIFY BY HAND

part of tavern.models;

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class Post
// **************************************************************************

Post _$PostFromJson(Map json) => new Post(json['name'], json['url']);

abstract class _$PostSerializerMixin {
  String get name;
  String get url;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'url': url};
}

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

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class Metadata
// **************************************************************************

Metadata _$MetadataFromJson(Map json) => new Metadata(
    json['title'],
    json['template'],
    json['category'],
    (json['tags'] as List)?.map((v0) => v0)?.toList(),
    json['url'],
    (json['all_tags'] as List)
        ?.map((v0) => v0 == null ? null : new Tag.fromJson(v0))
        ?.toList());

abstract class _$MetadataSerializerMixin {
  String get title;
  String get template;
  String get category;
  List get tags;
  String get url;
  List get allTags;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'template': template,
        'category': category,
        'tags': tags,
        'url': url,
        'all_tags': allTags
      };
}

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class Tag
// **************************************************************************

Tag _$TagFromJson(Map json) => new Tag(json['name'], json['url']);

abstract class _$TagSerializerMixin {
  String get name;
  String get url;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'url': url};
}

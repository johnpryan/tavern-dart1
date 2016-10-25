// GENERATED CODE - DO NOT MODIFY BY HAND

part of tavern.settings;

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class TavernSettings
// **************************************************************************

TavernSettings _$TavernSettingsFromJson(Map json) => new TavernSettings(
    siteUrl: json['site_url'],
    sitemapPath: json['sitemap_path'],
    tagPagePath: json['tag_page_path'],
    tagPageIndex: json['tag_page_index']);

abstract class _$TavernSettingsSerializerMixin {
  String get siteUrl;
  String get sitemapPath;
  String get tagPagePath;
  String get tagPageIndex;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'site_url': siteUrl,
        'sitemap_path': sitemapPath,
        'tag_page_path': tagPagePath,
        'tag_page_index': tagPageIndex
      };
}

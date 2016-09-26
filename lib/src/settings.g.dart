// GENERATED CODE - DO NOT MODIFY BY HAND

part of tavern.settings;

// **************************************************************************
// Generator: JsonSerializableGenerator
// Target: class TavernSettings
// **************************************************************************

TavernSettings _$TavernSettingsFromJson(Map json) =>
    new TavernSettings(json['site_url'], json['sitemap_path']);

abstract class _$TavernSettingsSerializerMixin {
  String get siteUrl;
  String get sitemapPath;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'site_url': siteUrl, 'sitemap_path': sitemapPath};
}

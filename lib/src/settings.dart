library tavern.settings;

import 'package:source_gen/generators/json_serializable.dart';

part 'settings.g.dart';

@JsonSerializable()
class TavernSettings extends _$TavernSettingsSerializerMixin {
  /// The base URL of the site.
  @JsonKey('site_url')
  final String siteUrl;

  /// The location of the sitemap output. Relative to the web/ directory.
  @JsonKey('sitemap_path')
  final String sitemapPath;

  TavernSettings(String siteUrl, String sitemapPath)
      : this.siteUrl = stripTrailingSlash(siteUrl),
        this.sitemapPath = addLeadingSlash(sitemapPath);


  static String stripTrailingSlash(String s) {
    while (s?.endsWith('/') ?? false) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  static String addLeadingSlash(String s) {
    if (s != null && !s.startsWith('/')) {
      s = '/$s';
    }
    return s;
  }


  factory TavernSettings.fromJson(json) => _$TavernSettingsFromJson(json);
}

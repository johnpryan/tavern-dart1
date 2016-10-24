library tavern.settings;

import 'package:source_gen/generators/json_serializable.dart';
import 'package:tavern/src/utils.dart';

part 'settings.g.dart';

@JsonSerializable()
class TavernSettings extends _$TavernSettingsSerializerMixin {
  /// The base URL of the site.
  @JsonKey('site_url')
  final String siteUrl;

  /// The location of the sitemap output. Relative to the web/ directory.
  @JsonKey('sitemap_path')
  final String sitemapPath;

  @JsonKey('tag_page_path')
  final String tagPagePath;

  @JsonKey('tag_page_index')
  final String tagPageIndex;

  TavernSettings(
      {String siteUrl,
      String sitemapPath,
      String tagPagePath,
      String tagPageIndex})
      : this.siteUrl = stripTrailingSlash(siteUrl ?? "/"),
        this.sitemapPath = addLeadingSlash(sitemapPath ?? "/sitemap.xml"),
        this.tagPagePath = addLeadingSlash(tagPagePath ?? '/tags/{{tag}}.html'),
        this.tagPageIndex = addLeadingSlash(tagPageIndex ?? '/tags/index.html');

  factory TavernSettings.fromJson(json) => _$TavernSettingsFromJson(json);
}

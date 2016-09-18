class TavernSettings {
  /// The base URL of the site.
  String siteUrl;

  /// The location of the sitemap output.
  /// Relative to the web/ directory.
  String sitemapPath;

  TavernSettings.fromMap(Map map) {
    siteUrl = map['siteUrl'];
    sitemapPath = map['sitemapPath'];
    // strip trailing slash from siteUrl
    while (siteUrl?.endsWith('/') ?? false) {
      siteUrl = siteUrl.substring(0, siteUrl.length - 1);
    }
    // add leading slash to sitemapPath
    if (sitemapPath != null && !sitemapPath.startsWith('/')) {
      sitemapPath = '/$sitemapPath';
    }
  }
}

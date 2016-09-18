import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';

import 'settings.dart';

/// Generates a single sitemap.xml that can be used by crawlers to discover new
/// URLs on the site.
class Sitemap extends AggregateTransformer {
  static const indexFile = 'index.html';

  TavernSettings settings;
  Sitemap(this.settings);

  @override
  classifyPrimary(AssetId id) => id.extension == '.html' ? 'html' : null;

  @override
  Future apply(AggregateTransform transform) async {
    String sitemapPath = settings.sitemapPath ?? '/sitemap.xml';
    // Special sitemap value to disable generating sitemap
    if (sitemapPath == 'none') return;

    StringBuffer output = new StringBuffer(_urlSetBegin);
    await for (Asset input in transform.primaryInputs) {
      String url = input.id.path;
      if (!url.startsWith('web/')) continue;
      url = url.substring(3);
      if (url.endsWith('/$indexFile')) {
        url = url.substring(0, url.length - indexFile.length);
      }
      if (settings.siteUrl != null) {
        url = '${settings.siteUrl}$url';
      }
      output.write(_wrap(url));
    }
    output.write(_urlSetEnd);
    var id = new AssetId(transform.package, 'web$sitemapPath');
    transform.addOutput(new Asset.fromString(id, output.toString()));
  }
}

const _urlSetBegin =
    r'<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" '
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
    'xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 '
    'http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">\n';
const _urlSetEnd = '</urlset>\n';
HtmlEscape _htmlEscape = const HtmlEscape(HtmlEscapeMode.ELEMENT);
String _wrap(String url) =>
    '<url><loc>${_htmlEscape.convert(url)}</loc></url>\n';

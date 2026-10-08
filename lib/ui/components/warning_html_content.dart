import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;
import 'package:url_launcher/url_launcher.dart';

/// Renders the HTML body of a warning (`content`) authored in the web panel.
///
/// The text is rich HTML — headings, lists, colors, alignment, links — so it
/// must never be shown through a plain [Text] widget.
class WarningHtmlContent extends StatelessWidget {
  final String html;

  const WarningHtmlContent({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      textStyle: TextStyle(
        fontSize: 15,
        height: 1.45,
        color: context.isDark() ? Colors.white : Colors.black87,
      ),
      onTapUrl: (url) async {
        if (url.isEmpty) return false;
        final uri = Uri.tryParse(url);
        if (uri == null) return false;
        // Links always leave the app.
        if (await canLaunchUrl(uri)) {
          return launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        return false;
      },
    );
  }
}

/// Tag-free excerpt of an HTML body, for list subtitles.
String htmlToPlainText(String? html) {
  if (html == null || html.isEmpty) return '';
  return html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'</(p|div|li|h[1-6])>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

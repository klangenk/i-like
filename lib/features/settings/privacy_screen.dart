import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/round_icon_button.dart';

/// Shows the bundled privacy policy (German PRIVACY.md, English
/// PRIVACY.en.md for every other locale), so it is readable offline.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final asset = Localizations.localeOf(context).languageCode == 'de'
        ? 'PRIVACY.md'
        : 'PRIVACY.en.md';

    final styleSheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      h1: theme.textTheme.headlineMedium,
      h2: theme.textTheme.titleLarge,
      h3: theme.textTheme.titleMedium,
      h2Padding: const EdgeInsets.only(top: 8),
      p: const TextStyle(fontSize: 15, height: 1.5),
      listBullet: const TextStyle(fontSize: 15, height: 1.5),
      a: TextStyle(color: scheme.tertiary, fontWeight: FontWeight.w600),
      em: TextStyle(color: scheme.onSurfaceVariant, fontStyle: FontStyle.normal),
      tableHead: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      tableBody: const TextStyle(fontSize: 13, height: 1.4),
      tableBorder: TableBorder.all(color: scheme.outline),
      tableCellsPadding: const EdgeInsets.all(8),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      blockSpacing: 14,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 68,
        titleSpacing: 16,
        title: RoundIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(asset),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Markdown(
            data: snapshot.data!,
            styleSheet: styleSheet,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            onTapLink: (text, href, title) {
              if (href != null) openUrl(href);
            },
          );
        },
      ),
    );
  }
}

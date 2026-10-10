import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/rating_level.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_provider.dart';
import 'export_import_service.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratings = ref.watch(ratingsProvider).valueOrNull ?? const [];
    final version = ref.watch(_packageInfoProvider).valueOrNull;

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Text(l10n.settingsTitle, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 20),

          if (ratings.isNotEmpty) ...[
            _BalanceCard(ratings: ratings),
            const SizedBox(height: 24),
          ],

          _SectionLabel(l10n.dataTitle),
          _SettingsRow(
            icon: Icons.upload_rounded,
            title: l10n.exportJsonLong,
            onTap: _handleExport,
          ),
          _SettingsRow(
            icon: Icons.table_chart_outlined,
            title: l10n.exportCsvLong,
            onTap: _handleExportCsv,
          ),
          _SettingsRow(
            icon: Icons.download_rounded,
            title: l10n.importRatings,
            onTap: _handleImport,
          ),
          const SizedBox(height: 24),

          _SectionLabel(l10n.aboutTitle),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: l10n.privacyPolicy,
            trailing: Icon(Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            onTap: () => context.push('/privacy'),
          ),
          _SettingsRow(
            icon: Icons.info_outline_rounded,
            title: l10n.version,
            trailing: Text(
              version == null ? '' : '${version.version} (${version.buildNumber})',
              style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final dao = ref.read(ratingsDaoProvider);

    final json = await ExportImportService.exportToJson(dao);

    // Check if there are any ratings
    final ratings = await dao.getAll();
    if (ratings.isEmpty) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.noRatingsToExport)),
        );
      }
      return;
    }

    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/i_like_export_$date.json');
    await file.writeAsString(json);

    await Share.shareXFiles([XFile(file.path)]);

    if (mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess(ratings.length))),
      );
    }
  }

  Future<void> _handleExportCsv() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final dao = ref.read(ratingsDaoProvider);

    final ratings = await dao.getAll();
    if (ratings.isEmpty) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.noRatingsToExport)),
        );
      }
      return;
    }

    final csvBytes = await ExportImportService.exportToCsv(dao);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/i_like_export_$date.csv');
    await file.writeAsBytes(csvBytes);

    await Share.shareXFiles([XFile(file.path)]);

    if (mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.exportSuccess(ratings.length))),
      );
    }
  }

  Future<void> _handleImport() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) return;

    try {
      final path = result.files.single.path;
      if (path == null) throw Exception('No file path');

      final contents = await File(path).readAsString();
      final dao = ref.read(ratingsDaoProvider);
      final (:imported, :skipped) =
          await ExportImportService.importFromJson(contents, dao);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.importSuccess(imported, skipped))),
        );
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.importError)),
        );
      }
    }
  }
}

/// Distribution of ratings over the five levels, as one segmented bar.
class _BalanceCard extends StatelessWidget {
  final List<Rating> ratings;

  const _BalanceCard({required this.ratings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final counts = {for (final l in RatingLevel.values) l: 0};
    for (final r in ratings) {
      final level = RatingLevel.fromScore(r.score);
      if (level != null) counts[level] = counts[level]! + 1;
    }
    final present = RatingLevel.bestFirst.where((l) => counts[l]! > 0).toList();
    final summary = RatingLevel.bestFirst
        .map((l) => '${l.word(l10n)} ${counts[l]}')
        .join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.yourBalance,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Text(l10n.ratingsCount(ratings.length), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          Semantics(
            label: summary,
            excludeSemantics: true,
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  for (final l in present) ...[
                    Expanded(
                      flex: counts[l]!,
                      child: Container(
                        decoration: BoxDecoration(
                          color: l.dot,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    if (l != present.last) const SizedBox(width: 3),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final l in RatingLevel.bestFirst)
                Text(
                  '${l.word(l10n)} ${counts[l]}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 54),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

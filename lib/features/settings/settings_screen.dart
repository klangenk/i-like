import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_provider.dart';
import 'export_import_service.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _tmdbController;
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    _tmdbController = TextEditingController();
  }

  @override
  void dispose() {
    _tmdbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tmdbKey = ref.watch(tmdbApiKeyProvider);
    final hasKey = tmdbKey.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.movie_outlined, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.tmdbTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tmdbDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  if (hasKey) ...[
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.apiKeyConfigured)),
                        TextButton(
                          onPressed: () async {
                            await ref.read(tmdbApiKeyProvider.notifier).clearApiKey();
                          },
                          child: Text(l10n.removeKey, style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ] else ...[
                    TextField(
                      controller: _tmdbController,
                      obscureText: _obscureKey,
                      decoration: InputDecoration(
                        hintText: l10n.enterTmdbApiKey,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _obscureKey = !_obscureKey),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () async {
                                final key = _tmdbController.text.trim();
                                if (key.isNotEmpty) {
                                  final messenger = ScaffoldMessenger.of(context);
                                  await ref.read(tmdbApiKeyProvider.notifier).setApiKey(key);
                                  _tmdbController.clear();
                                  if (mounted) {
                                    messenger.showSnackBar(
                                      SnackBar(content: Text(l10n.tmdbApiKeySaved)),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.placesTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.placesDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.readyToUse),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.import_export, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.dataTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.upload),
                          label: Text(l10n.exportRatings),
                          onPressed: _handleExport,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.table_chart_outlined),
                          label: Text(l10n.exportCsv),
                          onPressed: _handleExportCsv,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: Text(l10n.importRatings),
                      onPressed: _handleImport,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
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

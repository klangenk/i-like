import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
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
        ],
      ),
    );
  }
}

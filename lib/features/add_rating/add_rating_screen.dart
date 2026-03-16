import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/image_store.dart';
import '../../l10n/app_localizations.dart';
import '../home/home_provider.dart';
import 'add_rating_provider.dart';
import 'widgets/star_input.dart';
import 'widgets/tag_input.dart';

class AddRatingScreen extends ConsumerStatefulWidget {
  final PrefillData? prefill;

  const AddRatingScreen({super.key, this.prefill});

  @override
  ConsumerState<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends ConsumerState<AddRatingScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  String _lastProviderTitle = '';

  @override
  void initState() {
    super.initState();
    if (widget.prefill != null) {
      final p = widget.prefill!;
      _titleController.text = p.title;
      _notesController.text = p.notes;
      _lastProviderTitle = p.title;
      // Defer provider updates to after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(addRatingProvider.notifier);
        notifier.prefill(
          title: p.title,
          imageUrl: p.imageUrl,
          tags: p.tags,
          barcode: p.barcode,
          sourceUrl: p.sourceUrl,
        );
        if (p.notes.isNotEmpty) {
          notifier.setNotes(p.notes);
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveRating() async {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(addRatingProvider);
    if (state.title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterTitle)),
      );
      return;
    }
    if (state.score == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseGiveRating)),
      );
      return;
    }

    final localImagePath = await ImageStore.downloadAndStore(state.imageUrl);

    final dao = ref.read(ratingsDaoProvider);
    await dao.insertRating(RatingsCompanion(
      title: Value(state.title),
      score: Value(state.score),
      tags: Value(state.tags.join(', ')),
      notes: Value(state.notes),
      imageUrl: Value(state.imageUrl),
      sourceUrl: Value(state.sourceUrl),
      barcode: Value(state.barcode),
      localImagePath: Value(localImagePath ?? ''),
    ));

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(addRatingProvider);
    final notifier = ref.read(addRatingProvider.notifier);

    // Sync title controller when provider updates asynchronously (e.g. metadata fetch)
    if (state.title != _lastProviderTitle && state.title != _titleController.text) {
      _lastProviderTitle = state.title;
      _titleController.text = state.title;
    }
    _lastProviderTitle = state.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addRatingTitle),
        actions: [
          TextButton(
            onPressed: _saveRating,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image preview
                  if (state.imageUrl.isNotEmpty) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: state.imageUrl,
                        height: 150,
                        fit: BoxFit.contain,
                        errorWidget: (_, _, _) => Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.broken_image_outlined,
                              size: 40, color: Colors.grey.withAlpha(120)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.titleRequired,
                      hintText: l10n.titleHint,
                    ),
                    onChanged: notifier.setTitle,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 24),

                  // Star Rating
                  Text(
                    l10n.rating,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  StarInput(
                    score: state.score,
                    onChanged: notifier.setScore,
                  ),
                  if (state.score > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l10n.scoreDisplay(state.score.toInt().toString()),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Tags
                  Text(
                    l10n.tags,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TagInput(
                    tags: state.tags,
                    onTagAdded: notifier.addTag,
                    onTagRemoved: notifier.removeTag,
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: l10n.notes,
                      hintText: l10n.notesHint,
                      alignLabelWithHint: true,
                    ),
                    onChanged: notifier.setNotes,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}

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
import '../../shared/widgets/round_icon_button.dart';
import 'widgets/level_picker.dart';
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
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            RoundIconButton(
              icon: Icons.close_rounded,
              tooltip: l10n.close,
              onPressed: () => context.pop(),
            ),
            const SizedBox(width: 12),
            Text(l10n.addRatingTitle),
          ],
        ),
      ),
      bottomNavigationBar: state.isLoading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: FilledButton(
                  onPressed: _saveRating,
                  child: Text(l10n.save),
                ),
              ),
            ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Item: image + title
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        if (state.imageUrl.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: state.imageUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => const SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(Icons.image_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: l10n.titleHint,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              focusedBorder: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            maxLines: null,
                            onChanged: notifier.setTitle,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(l10n.howWasIt, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 18),
                  LevelPicker(
                    score: state.score,
                    onChanged: notifier.setScore,
                  ),
                  const SizedBox(height: 28),

                  Text(l10n.category.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 10),
                  TagInput(
                    tags: state.tags,
                    onTagAdded: notifier.addTag,
                    onTagRemoved: notifier.removeTag,
                  ),
                  const SizedBox(height: 24),

                  Text(l10n.notes.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    decoration: InputDecoration(hintText: l10n.notesHint),
                    onChanged: notifier.setNotes,
                    maxLines: 4,
                    minLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
    );
  }
}

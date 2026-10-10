import 'dart:io';

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
import '../../core/utils/photo_insights.dart';
import '../../core/utils/tag_l10n.dart';
import '../../shared/widgets/photo_picker.dart';
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
  final _creatorController = TextEditingController();
  final _yearController = TextEditingController();
  String _lastProviderCreator = '';

  @override
  void initState() {
    super.initState();
    if (widget.prefill != null) {
      final p = widget.prefill!;
      _titleController.text = p.title;
      _notesController.text = p.notes;
      _lastProviderTitle = p.title;
      _creatorController.text = p.creator;
      _yearController.text = p.year;
      _lastProviderCreator = p.creator;
      // Defer provider updates to after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(addRatingProvider.notifier);
        notifier.prefill(
          title: p.title,
          imageUrl: p.imageUrl,
          tags: p.tags,
          barcode: p.barcode,
          sourceUrl: p.sourceUrl,
          creator: p.creator,
          year: p.year,
        );
        if (p.notes.isNotEmpty) {
          notifier.setNotes(p.notes);
        }
      });
    }
  }

  /// Set once the rating is stored, so [dispose] keeps the picked photo.
  bool _saved = false;
  String _pickedPath = '';

  /// On-device suggestions (title candidates, categories) for the picked photo.
  PhotoInsights? _insights;
  bool _analyzing = false;

  Future<void> _analyze(String path) async {
    setState(() {
      _analyzing = true;
      _insights = null;
    });
    final insights = await analyzePhoto(path);
    if (!mounted || path != _pickedPath) return;
    setState(() {
      _analyzing = false;
      _insights = insights;
    });
  }

  Future<void> _pickPhoto(AddRatingState state) async {
    final pick = await pickRatingPhoto(
      context,
      canRemove: state.imageUrl.isNotEmpty || state.localImagePath.isNotEmpty,
    );
    if (pick == null || !mounted) return;
    final notifier = ref.read(addRatingProvider.notifier);
    // A replaced photo that was never saved is just a stray file.
    if (_pickedPath.isNotEmpty) ImageStore.delete(_pickedPath);
    switch (pick) {
      case PhotoPicked(:final localPath):
        _pickedPath = localPath;
        notifier.setLocalImage(localPath);
        _analyze(localPath);
      case PhotoRemoved():
        _pickedPath = '';
        notifier.clearImage();
        setState(() {
          _insights = null;
          _analyzing = false;
        });
    }
  }

  @override
  void dispose() {
    if (!_saved && _pickedPath.isNotEmpty) ImageStore.delete(_pickedPath);
    _titleController.dispose();
    _creatorController.dispose();
    _yearController.dispose();
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

    final localImagePath = state.localImagePath.isNotEmpty
        ? state.localImagePath
        : await ImageStore.downloadAndStore(state.imageUrl);
    _saved = true;

    final dao = ref.read(ratingsDaoProvider);
    await dao.insertRating(RatingsCompanion(
      title: Value(state.title),
      score: Value(state.score),
      tags: Value(state.tags.join(', ')),
      notes: Value(state.notes),
      imageUrl: Value(state.imageUrl),
      sourceUrl: Value(state.sourceUrl),
      barcode: Value(state.barcode),
      creator: Value(state.creator.trim()),
      year: Value(state.year.trim()),
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
    // Same for the creator, which shared links may fill in after a fetch
    if (state.creator != _lastProviderCreator && state.creator != _creatorController.text) {
      _creatorController.text = state.creator;
    }
    _lastProviderCreator = state.creator;
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
                        _PhotoSlot(
                          imageUrl: state.imageUrl,
                          localImagePath: state.localImagePath,
                          onTap: () => _pickPhoto(state),
                        ),
                        const SizedBox(width: 4),
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
                  if (_analyzing || !(_insights?.isEmpty ?? true)) ...[
                    const SizedBox(height: 10),
                    _PhotoSuggestions(
                      analyzing: _analyzing,
                      insights: _insights,
                      selectedTags: state.tags,
                      onTitle: (title) {
                        _titleController.text = title;
                        notifier.setTitle(title);
                      },
                      onTag: notifier.addTag,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _creatorController,
                          decoration: InputDecoration(
                            labelText: l10n.creatorLabel,
                            hintText: l10n.creatorHint,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: notifier.setCreator,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _yearController,
                          decoration: InputDecoration(
                            labelText: l10n.yearLabel,
                            hintText: '2026',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterText: '',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          onChanged: notifier.setYear,
                        ),
                      ),
                    ],
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

/// 64 px photo tile in the item card; tap to take, pick or remove a photo.
class _PhotoSlot extends StatelessWidget {
  final String imageUrl;
  final String localImagePath;
  final VoidCallback onTap;

  const _PhotoSlot({required this.imageUrl, required this.localImagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final hasImage = imageUrl.isNotEmpty || localImagePath.isNotEmpty;
    final placeholder = Container(
      color: scheme.surface,
      alignment: Alignment.center,
      child: Icon(Icons.add_a_photo_outlined, color: scheme.onSurfaceVariant),
    );

    return Semantics(
      button: true,
      label: hasImage ? l10n.changePhoto : l10n.addPhoto,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: localImagePath.isNotEmpty
                    ? Image.file(File(localImagePath), fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => placeholder)
                    : imageUrl.isNotEmpty
                        ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover,
                            errorWidget: (_, _, _) => placeholder)
                        : placeholder,
              ),
              if (hasImage)
                Positioned(
                  right: 3,
                  bottom: 3,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: scheme.surface, shape: BoxShape.circle),
                    child: Icon(Icons.edit_rounded, size: 12, color: scheme.onSurface),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Suggestions from the photo": tap a title candidate to use it, tap a
/// category to add it.
class _PhotoSuggestions extends StatelessWidget {
  final bool analyzing;
  final PhotoInsights? insights;
  final List<String> selectedTags;
  final ValueChanged<String> onTitle;
  final ValueChanged<String> onTag;

  const _PhotoSuggestions({
    required this.analyzing,
    required this.insights,
    required this.selectedTags,
    required this.onTitle,
    required this.onTag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tags = (insights?.tags ?? const []).where((t) => !selectedTags.contains(t)).toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_outlined, size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                analyzing ? l10n.analyzingPhoto : l10n.photoSuggestions,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              if (analyzing) ...[
                const SizedBox(width: 8),
                const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ],
          ),
          if (!analyzing) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final title in insights?.titles ?? const <String>[])
                  ActionChip(
                    avatar: const Icon(Icons.title_rounded, size: 16),
                    label: Text(title),
                    onPressed: () => onTitle(title),
                  ),
                for (final tag in tags)
                  ActionChip(
                    avatar: const Icon(Icons.add_rounded, size: 16),
                    label: Text(localizedTagName(tag, l10n)),
                    onPressed: () => onTag(tag),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

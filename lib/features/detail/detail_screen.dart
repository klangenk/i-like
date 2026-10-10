import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/image_store.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/rating_level.dart';
import '../../core/utils/date_label.dart';
import '../../core/utils/tag_l10n.dart';
import '../../shared/widgets/level_badge.dart';
import '../../shared/widgets/photo_picker.dart';
import '../../shared/widgets/rating_image.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../home/home_provider.dart';
import 'detail_provider.dart';
import '../add_rating/widgets/level_picker.dart';
import '../add_rating/widgets/tag_input.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int ratingId;

  const DetailScreen({super.key, required this.ratingId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  final _creatorController = TextEditingController();
  final _yearController = TextEditingController();
  double _editScore = 0;
  List<String> _editTags = [];
  String _editImageUrl = '';
  String _editLocalPath = '';

  /// Photo picked during this edit session; deleted again if not saved.
  String? _pickedPath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _discardPickedPhoto();
    _titleController.dispose();
    _notesController.dispose();
    _creatorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _startEditing(Rating rating) {
    setState(() {
      _isEditing = true;
      _titleController.text = rating.title;
      _notesController.text = rating.notes;
      _creatorController.text = rating.creator;
      _yearController.text = rating.year;
      _editScore = rating.score;
      _editImageUrl = rating.imageUrl;
      _editLocalPath = rating.localImagePath;
      _editTags = rating.tags
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
    });
  }

  Future<void> _saveEdits(Rating rating) async {
    final dao = ref.read(ratingsDaoProvider);
    final updated = rating.copyWith(
      title: _titleController.text,
      notes: _notesController.text,
      score: _editScore,
      tags: _editTags.join(', '),
      imageUrl: _editImageUrl,
      localImagePath: _editLocalPath,
      creator: _creatorController.text.trim(),
      year: _yearController.text.trim(),
      updatedAt: DateTime.now(),
    );
    await dao.updateRating(updated);
    if (rating.localImagePath.isNotEmpty && rating.localImagePath != _editLocalPath) {
      ImageStore.delete(rating.localImagePath);
    }
    _pickedPath = null;
    setState(() => _isEditing = false);
  }

  void _cancelEditing() {
    _discardPickedPhoto();
    setState(() => _isEditing = false);
  }

  void _discardPickedPhoto() {
    if (_pickedPath != null) ImageStore.delete(_pickedPath);
    _pickedPath = null;
  }

  Future<void> _pickPhoto() async {
    final pick = await pickRatingPhoto(
      context,
      canRemove: _editImageUrl.isNotEmpty || _editLocalPath.isNotEmpty,
    );
    if (pick == null || !mounted) return;
    _discardPickedPhoto();
    setState(() {
      switch (pick) {
        case PhotoPicked(:final localPath):
          _pickedPath = localPath;
          _editLocalPath = localPath;
        case PhotoRemoved():
          _editLocalPath = '';
          _editImageUrl = '';
      }
    });
  }

  Future<void> _deleteRating() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteRating),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final rating = ref.read(ratingDetailProvider(widget.ratingId)).valueOrNull;
      await ImageStore.delete(rating?.localImagePath);
      await ref.read(ratingsDaoProvider).deleteRating(widget.ratingId);
      if (mounted) context.pop();
    }
  }

  void _shareRating(Rating rating) {
    final l10n = AppLocalizations.of(context)!;
    final level = RatingLevel.fromScore(rating.score);
    final buffer = StringBuffer();
    buffer.writeln(level == null
        ? rating.title
        : '${rating.title} – ${level.word(l10n)} (${level.value}/5)');
    if (rating.creator.isNotEmpty) {
      buffer.writeln(l10n.byCreator(rating.creator));
    }
    if (rating.tags.isNotEmpty) {
      buffer.writeln('Tags: ${rating.tags}');
    }
    if (rating.notes.isNotEmpty) {
      buffer.writeln(rating.notes);
    }
    if (rating.sourceUrl.isNotEmpty) {
      buffer.writeln(rating.sourceUrl);
    }
    Share.share(buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratingAsync = ref.watch(ratingDetailProvider(widget.ratingId));
    final rating = ratingAsync.valueOrNull;

    return Scaffold(
      bottomNavigationBar: rating == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: _isEditing
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 56)),
                              onPressed: _cancelEditing,
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => _saveEdits(rating),
                              child: Text(l10n.save),
                            ),
                          ),
                        ],
                      )
                    : FilledButton(
                        onPressed: () => _startEditing(rating),
                        child: Text(l10n.editRating),
                      ),
              ),
            ),
      body: ratingAsync.when(
        data: (rating) => _buildContent(rating),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.errorPrefix(error.toString()))),
      ),
    );
  }

  Widget _buildContent(Rating rating) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final level = RatingLevel.fromScore(rating.score);
    final tags = rating.tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final meta = [
      ...tags.map((t) => localizedTagName(t, l10n)),
      l10n.ratedOn(longDateLabel(context, rating.createdAt)),
    ].join(' · ');

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo with actions and level
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: _isEditing ? 200 : 350,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RatingImage(
                      key: ValueKey(_isEditing ? '$_editLocalPath|$_editImageUrl' : rating.localImagePath),
                      imageUrl: _isEditing ? _editImageUrl : rating.imageUrl,
                      localImagePath: _isEditing ? _editLocalPath : rating.localImagePath,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(30),
                      placeholder: Container(
                        color: scheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_outlined,
                          size: 56,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        children: [
                          RoundIconButton(
                            icon: Icons.arrow_back_rounded,
                            tooltip: l10n.back,
                            background: scheme.surface,
                            onPressed: () => context.pop(),
                          ),
                          const Spacer(),
                          if (!_isEditing) ...[
                            RoundIconButton(
                              icon: Icons.ios_share_rounded,
                              tooltip: l10n.share,
                              background: scheme.surface,
                              onPressed: () => _shareRating(rating),
                            ),
                            const SizedBox(width: 8),
                          ],
                          RoundIconButton(
                            icon: Icons.delete_outline_rounded,
                            tooltip: l10n.delete,
                            background: scheme.surface,
                            foreground: scheme.error,
                            onPressed: _deleteRating,
                          ),
                        ],
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 16,
                        child: Center(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              backgroundColor: scheme.surface,
                              foregroundColor: scheme.onSurface,
                            ),
                            onPressed: _pickPhoto,
                            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                            label: Text(
                              _editImageUrl.isEmpty && _editLocalPath.isEmpty
                                  ? l10n.addPhoto
                                  : l10n.changePhoto,
                            ),
                          ),
                        ),
                      ),
                    if (level != null && !_isEditing)
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: LevelBadge(level: level, large: true),
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isEditing)
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: l10n.titleHint),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      maxLines: null,
                    )
                  else ...[
                    Text(rating.title, style: Theme.of(context).textTheme.headlineMedium),
                    if (rating.creator.isNotEmpty || rating.year.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        [
                          if (rating.creator.isNotEmpty) l10n.byCreator(rating.creator),
                          if (rating.year.isNotEmpty) rating.year,
                        ].join(' · '),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(meta, style: TextStyle(fontSize: 15, color: scheme.onSurfaceVariant)),
                  ],
                  const SizedBox(height: 20),

                  if (_isEditing) ...[
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
                            textCapitalization: TextCapitalization.words,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _yearController,
                            decoration: InputDecoration(
                              labelText: l10n.yearLabel,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              counterText: '',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    LevelPicker(
                      score: _editScore,
                      onChanged: (s) => setState(() => _editScore = s),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.category.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 10),
                    TagInput(
                      tags: _editTags,
                      onTagAdded: (tag) => setState(() {
                        if (!_editTags.contains(tag)) _editTags.add(tag);
                      }),
                      onTagRemoved: (tag) => setState(() => _editTags.remove(tag)),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.notes.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(hintText: l10n.notesHint),
                      maxLines: 4,
                      minLines: 2,
                    ),
                  ] else ...[
                    if (level != null) LevelScale(level: level),
                    if (rating.notes.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Text(rating.notes, style: const TextStyle(fontSize: 16, height: 1.45)),
                    ],
                    if (rating.sourceUrl.isNotEmpty || rating.barcode.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      const Divider(),
                    ],
                    if (rating.sourceUrl.isNotEmpty)
                      _InfoRow(
                        label: l10n.source,
                        onTap: () => openUrl(rating.sourceUrl),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                extractDomain(rating.sourceUrl) ?? rating.sourceUrl,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.tertiary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.north_east_rounded, size: 15, color: scheme.tertiary),
                          ],
                        ),
                      ),
                    if (rating.sourceUrl.isNotEmpty && rating.barcode.isNotEmpty) const Divider(),
                    if (rating.barcode.isNotEmpty)
                      _InfoRow(
                        label: l10n.barcodeLabel,
                        child: Text(
                          rating.barcode,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    if (rating.updatedAt != rating.createdAt) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.updated(longDateLabel(context, rating.updatedAt)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback? onTap;

  const _InfoRow({required this.label, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Expanded(child: Align(alignment: Alignment.centerRight, child: child)),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/app_database.dart';
import '../../core/utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/star_display.dart';
import '../../shared/widgets/tag_badge.dart';
import '../home/home_provider.dart';
import 'detail_provider.dart';
import '../add_rating/widgets/star_input.dart';
import '../add_rating/widgets/tag_input.dart';

final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

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
  double _editScore = 0;
  List<String> _editTags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _startEditing(Rating rating) {
    setState(() {
      _isEditing = true;
      _titleController.text = rating.title;
      _notesController.text = rating.notes;
      _editScore = rating.score;
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
      updatedAt: DateTime.now(),
    );
    await dao.updateRating(updated);
    setState(() => _isEditing = false);
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
      await ref.read(ratingsDaoProvider).deleteRating(widget.ratingId);
      if (mounted) context.pop();
    }
  }

  void _shareRating(Rating rating) {
    final stars = '${'★' * rating.score.floor()}${'☆' * (5 - rating.score.floor())}';
    final buffer = StringBuffer();
    buffer.writeln('${rating.title} $stars (${rating.score.toInt()}/5)');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailsTitle),
        actions: [
          if (!_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                final rating = ratingAsync.valueOrNull;
                if (rating != null) _shareRating(rating);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final rating = ratingAsync.valueOrNull;
                if (rating != null) _startEditing(rating);
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteRating,
          ),
        ],
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
    final tags = rating.tags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rating.imageUrl.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: rating.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                  errorWidget: (_, _, _) => Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.broken_image_outlined,
                        size: 48, color: Colors.grey.withAlpha(120)),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),

          if (_isEditing)
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.titleRequired),
              style: Theme.of(context).textTheme.headlineSmall,
            )
          else
            Text(
              rating.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(height: 16),

          if (_isEditing)
            StarInput(
              score: _editScore,
              onChanged: (s) => setState(() => _editScore = s),
            )
          else
            Center(child: StarDisplay(score: rating.score, size: 32)),
          const SizedBox(height: 8),
          Center(
            child: Text(
              l10n.scoreDisplay((_isEditing ? _editScore : rating.score).toInt().toString()),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          if (_isEditing) ...[
            TagInput(
              tags: _editTags,
              onTagAdded: (tag) => setState(() {
                if (!_editTags.contains(tag)) _editTags.add(tag);
              }),
              onTagRemoved: (tag) => setState(() => _editTags.remove(tag)),
            ),
            const SizedBox(height: 16),
          ] else if (tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags.map((t) => TagBadge(tag: t)).toList(),
            ),
            const SizedBox(height: 16),
          ],

          if (_isEditing) ...[
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l10n.notes),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _saveEdits(rating),
              child: Text(l10n.saveChanges),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              child: Text(l10n.cancel),
            ),
          ] else if (rating.notes.isNotEmpty) ...[
            Text(
              l10n.notes,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(rating.notes),
          ],

          if (rating.sourceUrl.isNotEmpty && !_isEditing) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => openUrl(rating.sourceUrl),
              icon: const Icon(Icons.link, size: 18),
              label: Text(
                extractDomain(rating.sourceUrl) ?? rating.sourceUrl,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          if (rating.barcode.isNotEmpty && !_isEditing) ...[
            const SizedBox(height: 12),
            Text(
              l10n.barcode(rating.barcode),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],

          if (!_isEditing) ...[
            const SizedBox(height: 24),
            Text(
              l10n.created(_dateFormat.format(rating.createdAt)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (rating.updatedAt != rating.createdAt)
              Text(
                l10n.updated(_dateFormat.format(rating.updatedAt)),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ],
      ),
    );
  }
}

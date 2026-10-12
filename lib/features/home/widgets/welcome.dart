import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/rating_level.dart';
import '../../../l10n/app_localizations.dart';

/// First-run screen: what the app is for and the three ways to add something.
class Welcome extends StatelessWidget {
  final VoidCallback onGetStarted;

  const Welcome({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.welcomeTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeSubtitle,
            style: TextStyle(fontSize: 16, height: 1.4, color: AppColors.muted(context)),
          ),
          const SizedBox(height: 28),
          _Way(
            icon: Icons.qr_code_scanner_rounded,
            title: l10n.welcomeScanTitle,
            text: l10n.welcomeScanText,
          ),
          _Way(
            icon: Icons.ios_share_rounded,
            title: l10n.welcomeShareTitle,
            text: l10n.welcomeShareText,
          ),
          _Way(
            icon: Icons.photo_camera_outlined,
            title: l10n.welcomeManualTitle,
            text: l10n.welcomeManualText,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.raspberry,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 56),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.getStarted),
              onPressed: onGetStarted,
            ),
          ),
        ],
      ),
    );
  }
}

class _Way extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _Way({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: RatingLevel.liebe.tint(context),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: AppColors.heart),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(fontSize: 15, height: 1.35, color: AppColors.muted(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One-time hint on the home screen that links can be shared into the app.
class ShareTip extends StatelessWidget {
  final VoidCallback onDismiss;

  const ShareTip({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
      decoration: BoxDecoration(
        color: RatingLevel.liebe.tint(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.ios_share_rounded, size: 22, color: AppColors.heart),
          const SizedBox(width: 12),
          Expanded(
            child: Text(l10n.shareTip, style: const TextStyle(fontSize: 15, height: 1.35)),
          ),
          IconButton(
            tooltip: l10n.close,
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}

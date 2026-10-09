import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

/// "heute", "gestern", or a short date like "16. März".
String shortDateLabel(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return l10n.today;
  if (diff == 1) return l10n.yesterday;
  final locale = Localizations.localeOf(context).toString();
  return day.year == today.year
      ? DateFormat.MMMMd(locale).format(date)
      : DateFormat.yMMMd(locale).format(date);
}

/// "16. März 2026".
String longDateLabel(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMMd(locale).format(date);
}

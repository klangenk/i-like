import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/add_rating/add_rating_screen.dart';
import '../../features/add_rating/add_rating_provider.dart';
import '../../features/add_rating/map_screen.dart';
import '../../features/add_rating/scanner_screen.dart';
import '../../features/detail/detail_screen.dart';
import '../../features/settings/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) {
        final prefill = state.extra as PrefillData?;
        return AddRatingScreen(prefill: prefill);
      },
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailScreen(ratingId: id);
      },
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import '../screens/welcome_screen.dart';
import '../screens/puzzle_screen.dart';

/// Application routing table using go_router.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LaunchGate()),
    GoRoute(
      path: '/tutorial/:lesson',
      builder: (context, state) {
        final requested =
            int.tryParse(state.pathParameters['lesson'] ?? '') ?? 0;
        final lesson = requested.clamp(0, 2);
        return PuzzleScreen(
          key: ValueKey('tutorial_$lesson'),
          size: 3,
          seed: -lesson - 1,
          lesson: lesson,
        );
      },
    ),
    GoRoute(
      path: '/puzzle',
      builder: (context, state) {
        final requested = int.tryParse(state.uri.queryParameters['size'] ?? '');
        final size = requested != null && requested >= 3 && requested <= 7
            ? requested
            : 4;
        final seed =
            int.tryParse(state.uri.queryParameters['seed'] ?? '') ?? 42;
        return PuzzleScreen(
          key: ValueKey((size, seed)),
          size: size,
          seed: seed < 0 ? 42 : seed,
        );
      },
    ),
  ],
);

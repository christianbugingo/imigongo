import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_flavor.dart';
import 'core/theme/imigongo_theme.dart';
import 'l10n/app_localizations.dart';
import 'ui/providers/locale_provider.dart';
import 'ui/providers/theme_provider.dart';
import 'ui/routing/app_router.dart';

void runImigongoApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ImigongoPuzzleApp()));
}

void main() {
  AppConfig.initialize(AppFlavor.prod);
  runImigongoApp();
}

class ImigongoPuzzleApp extends ConsumerWidget {
  const ImigongoPuzzleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final userLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: AppConfig.flavor.isDev,
      theme: ImigongoTheme.lightTheme,
      darkTheme: ImigongoTheme.darkTheme,
      themeMode: themeMode,
      locale: userLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        if (!MediaQuery.disableAnimationsOf(context)) return child!;
        return Theme(
          data: Theme.of(context).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _InstantTransition(),
                TargetPlatform.iOS: _InstantTransition(),
                TargetPlatform.macOS: _InstantTransition(),
                TargetPlatform.linux: _InstantTransition(),
                TargetPlatform.windows: _InstantTransition(),
                TargetPlatform.fuchsia: _InstantTransition(),
              },
            ),
          ),
          child: child!,
        );
      },
      routerConfig: appRouter,
    );
  }
}

class _InstantTransition extends PageTransitionsBuilder {
  const _InstantTransition();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

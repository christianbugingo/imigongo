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
  runApp(
    const ProviderScope(
      child: ImigongoPuzzleApp(),
    ),
  );
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
      title: AppConfig.flavor.appTitle,
      debugShowCheckedModeBanner: AppConfig.flavor.isDev,
      theme: ImigongoTheme.lightTheme,
      darkTheme: ImigongoTheme.darkTheme,
      themeMode: themeMode,
      locale: userLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}

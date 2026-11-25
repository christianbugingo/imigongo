import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/imigongo_palette.dart';
import '../../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.settings ?? 'Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Theme Section
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ImigongoPalette.ochre,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<ThemeMode>(
              groupValue: themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text('Dark Mode'),
                    value: ThemeMode.dark,
                    activeColor: ImigongoPalette.ochre,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('Light Mode'),
                    value: ThemeMode.light,
                    activeColor: ImigongoPalette.ochre,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text('System Default'),
                    value: ThemeMode.system,
                    activeColor: ImigongoPalette.ochre,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Language Section
          const Text(
            'Language / Ururimi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ImigongoPalette.ochre,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<String>(
              groupValue: currentLocale?.languageCode ?? 'en',
              onChanged: (code) {
                if (code != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(code));
                }
              },
              child: const Column(
                children: [
                  RadioListTile<String>(
                    title: Text('English'),
                    value: 'en',
                    activeColor: ImigongoPalette.ochre,
                  ),
                  RadioListTile<String>(
                    title: Text('Français (French)'),
                    value: 'fr',
                    activeColor: ImigongoPalette.ochre,
                  ),
                  RadioListTile<String>(
                    title: Text('Ikinyarwanda (Kinyarwanda)'),
                    value: 'rw',
                    activeColor: ImigongoPalette.ochre,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // About & Cultural Notes Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Imigongo Art Form',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Imigongo is a traditional geometric relief art form originating in Rwanda. '
                    'All cultural motifs and terminology are documented in docs/CULTURAL_REVIEW.md.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark
                          ? ImigongoPalette.parchment
                          : ImigongoPalette.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

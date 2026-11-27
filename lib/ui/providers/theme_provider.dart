import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

final themeModeProvider = Provider<ThemeMode>(
  (ref) => switch (ref.watch(settingsProvider).theme) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  },
);

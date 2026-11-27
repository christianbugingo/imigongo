import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

final localeProvider = Provider<Locale?>((ref) {
  final language = ref.watch(settingsProvider).language;
  return language == null ? null : Locale(language);
});

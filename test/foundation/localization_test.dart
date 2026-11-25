import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';

void main() {
  group('Localization Skeleton Tests (en, fr, rw)', () {
    test('Supported locales include English, French, and Kinyarwanda', () {
      final languageCodes = AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet();
      expect(languageCodes, containsAll(['en', 'fr', 'rw']));
    });

    test('English translations load correctly', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(l10n.appTitle, equals('Imigongo Puzzle'));
      expect(l10n.play, equals('Play'));
      expect(l10n.moves, equals('Moves'));
      expect(l10n.par, equals('Par'));
      expect(l10n.colorCharcoal, equals('Charcoal'));
      expect(l10n.starsEarned(1), equals('1 Star'));
      expect(l10n.starsEarned(3), equals('3 Stars'));
    });

    test('French translations load correctly', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('fr'));
      expect(l10n.appTitle, equals('Puzzle Imigongo'));
      expect(l10n.play, equals('Jouer'));
      expect(l10n.moves, equals('Mouvements'));
      expect(l10n.par, equals('Par'));
      expect(l10n.colorCharcoal, equals('Fusain'));
      expect(l10n.starsEarned(1), equals('1 Étoile'));
      expect(l10n.starsEarned(3), equals('3 Étoiles'));
    });

    test('Kinyarwanda placeholders load as stored (needs native review)', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('rw'));
      expect(l10n.appTitle, equals('Imigongo'));
      expect(l10n.play, equals('Gukina'));
      expect(l10n.moves, equals('Intambwe'));
      expect(l10n.par, equals('Intego'));
      expect(l10n.colorCharcoal, equals('Umukara'));
      expect(l10n.starsEarned(1), equals('Inyenyeri 1'));
      expect(l10n.starsEarned(3), equals('Inyenyeri 3'));
    });
  });
}


import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all ARBs have matching keys and every rw value has a review note', () {
    final arbs = <String, Map<String, dynamic>>{
      for (final locale in ['en', 'fr', 'rw'])
        locale: jsonDecode(
          File('lib/l10n/app_$locale.arb').readAsStringSync(),
        ) as Map<String, dynamic>,
    };
    Set<String> keys(String locale) =>
        arbs[locale]!.keys.where((k) => !k.startsWith('@')).toSet();
    expect(keys('fr'), keys('en'));
    expect(keys('rw'), keys('en'));
    for (final key in keys('en')) {
      expect(arbs['en']![key], isNotEmpty);
      expect(arbs['fr']![key], isNotEmpty);
      expect(
        (arbs['rw']!['@$key'] as Map<String, dynamic>)['description'],
        contains('needs native review'),
      );
    }
    expect(
      arbs['en']!['ruleOne'],
      'Tap a tile to turn it a quarter turn clockwise.',
    );
    expect(
      arbs['en']!['ruleTwo'],
      'Join the lines so no line ends in the open or points off the board.',
    );
    expect(
      arbs['en']!['ruleThree'],
      'Everything must connect into one single pattern.',
    );
    expect(
      arbs['en']!['ruleFour'],
      'Use as few turns as you can. Reach the target moves for three stars.',
    );
    expect(arbs['en']!['ruleFive'], 'Undo and Restart are always free.');
  });
}

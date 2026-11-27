import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all draft Kinyarwanda messages preserve parameters and native-review flags', () {
    final en = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final rw = jsonDecode(
      File('lib/l10n/app_rw.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    for (final key in en.keys.where((k) => !k.startsWith('@'))) {
      final value = rw[key] as String;
      expect(value.trim(), isNotEmpty, reason: key);
      final sourceMeta = en['@$key'] as Map<String, dynamic>;
      final placeholders =
          sourceMeta['placeholders'] as Map<String, dynamic>? ?? {};
      for (final name in placeholders.keys) {
        expect(
          value,
          matches(RegExp('\\{${RegExp.escape(name)}(?:\\}|,)')),
          reason: key,
        );
      }
      final meta = rw['@$key'] as Map<String, dynamic>;
      expect(meta['description'], contains('needs native review'), reason: key);
      expect(meta['description'], contains('DRAFT'), reason: key);
    }
  });
}

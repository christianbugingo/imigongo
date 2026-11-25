import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only the Riverpod puzzle controller accesses engine APIs', () {
    final imports = RegExp(r'''(?:import|export)\s+['"]([^'"]+)['"]''');
    expect(imports.hasMatch("import 'dart:ui';"), isTrue);
    expect(imports.hasMatch("export 'package:flutter/widgets.dart';"), isTrue);
    for (final file in Directory(
      'lib/ui',
    ).listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart') ||
          file.path.endsWith('/providers/puzzle_provider.dart')) {
        continue;
      }
      for (final match in imports.allMatches(file.readAsStringSync())) {
        expect(match.group(1), isNot(contains('/engine/')), reason: file.path);
      }
      expect(
        file.readAsStringSync(),
        isNot(contains('PuzzleValidator')),
        reason: file.path,
      );
      expect(
        file.readAsStringSync(),
        isNot(contains('rotateClockwise(')),
        reason: file.path,
      );
    }
  });
}

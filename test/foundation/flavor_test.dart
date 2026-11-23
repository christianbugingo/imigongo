import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/config/app_flavor.dart';

void main() {
  group('App Flavor Configuration Tests', () {
    test('Dev flavor uses .dev suffix and distinct title', () {
      expect(AppFlavor.dev.name, equals('dev'));
      expect(AppFlavor.dev.appTitle, equals('Imigongo Dev'));
      expect(AppFlavor.dev.applicationIdSuffix, equals('.dev'));
      expect(AppFlavor.dev.isDev, isTrue);
      expect(AppFlavor.dev.isProd, isFalse);
    });

    test('Prod flavor uses no suffix and default title', () {
      expect(AppFlavor.prod.name, equals('prod'));
      expect(AppFlavor.prod.appTitle, equals('Imigongo'));
      expect(AppFlavor.prod.applicationIdSuffix, isEmpty);
      expect(AppFlavor.prod.isProd, isTrue);
      expect(AppFlavor.prod.isDev, isFalse);
    });

    test('AppConfig initializes and toggles flavor', () {
      AppConfig.initialize(AppFlavor.dev);
      expect(AppConfig.flavor, equals(AppFlavor.dev));

      AppConfig.initialize(AppFlavor.prod);
      expect(AppConfig.flavor, equals(AppFlavor.prod));
    });
  });
}


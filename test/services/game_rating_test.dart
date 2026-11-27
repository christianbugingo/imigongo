import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_rating.dart';

class FakeRatingGateway implements RatingGateway {
  final List<String?> calls = [];
  bool fail = false;
  Completer<void>? gate;
  @override
  Future<void> openStoreListing({String? appStoreId}) async {
    calls.add(appStoreId);
    if (fail) throw StateError('store unavailable');
    await gate?.future;
  }
}

void main() {
  test('unreleased, malformed, unsupported and dev configurations never open a store', () async {
    final gateway = FakeRatingGateway();
    for (final (platform, config) in [
      (TargetPlatform.iOS, const RatingConfiguration(production: true)),
      (
        TargetPlatform.iOS,
        const RatingConfiguration(
          production: true,
          iosListingReady: true,
          appStoreId: 'YOUR_APP_ID',
        ),
      ),
      (TargetPlatform.android, const RatingConfiguration(production: true)),
      (
        TargetPlatform.iOS,
        const RatingConfiguration(
          production: false,
          iosListingReady: true,
          appStoreId: '123456789',
        ),
      ),
      (
        TargetPlatform.android,
        const RatingConfiguration(production: false, androidListingReady: true),
      ),
      (
        TargetPlatform.linux,
        const RatingConfiguration(production: true, androidListingReady: true),
      ),
    ]) {
      final rating = GameRating(
        gateway: gateway,
        config: config,
        platform: platform,
      );
      expect(rating.canOpen, isFalse);
      expect(await rating.openListing(), RatingOutcome.notConfigured);
    }
    expect(gateway.calls, isEmpty);
  });
  test('iOS uses numeric Apple ID; Android lets the plugin use installed package ID', () async {
    final gateway = FakeRatingGateway();
    final ios = GameRating(
      gateway: gateway,
      platform: TargetPlatform.iOS,
      config: const RatingConfiguration(
        production: true,
        iosListingReady: true,
        appStoreId: '123456789',
      ),
    );
    final android = GameRating(
      gateway: gateway,
      platform: TargetPlatform.android,
      config: const RatingConfiguration(
        production: true,
        androidListingReady: true,
      ),
    );
    expect(await ios.openListing(), RatingOutcome.openingRequested);
    expect(await android.openListing(), RatingOutcome.openingRequested);
    expect(gateway.calls, ['123456789', null]);
  });
  test('store failure can retry; concurrent taps issue one launch', () async {
    final gateway = FakeRatingGateway()..fail = true;
    final rating = GameRating(
      gateway: gateway,
      platform: TargetPlatform.android,
      config: const RatingConfiguration(
        production: true,
        androidListingReady: true,
      ),
    );
    expect(await rating.openListing(), RatingOutcome.failed);
    gateway.fail = false;
    gateway.gate = Completer<void>();
    final pending = rating.openListing();
    expect(await rating.openListing(), RatingOutcome.busy);
    gateway.gate!.complete();
    expect(await pending, RatingOutcome.openingRequested);
    expect(gateway.calls, hasLength(2));
  });
}

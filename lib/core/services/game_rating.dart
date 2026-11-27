import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

abstract class RatingGateway {
  Future<void> openStoreListing({String? appStoreId});
}

class NativeRatingGateway implements RatingGateway {
  @override
  Future<void> openStoreListing({String? appStoreId}) =>
      InAppReview.instance.openStoreListing(appStoreId: appStoreId);
}

class RatingConfiguration {
  final String appStoreId;
  final bool iosListingReady, androidListingReady, production;
  const RatingConfiguration({
    this.appStoreId = const String.fromEnvironment('APP_STORE_ID'),
    this.iosListingReady = const bool.fromEnvironment(
      'IOS_STORE_LISTING_READY',
    ),
    this.androidListingReady = const bool.fromEnvironment(
      'ANDROID_STORE_LISTING_READY',
    ),
    required this.production,
  });

  bool canOpen(TargetPlatform platform) {
    if (!production) return false;
    return switch (platform) {
      TargetPlatform.iOS =>
        iosListingReady && RegExp(r'^[1-9][0-9]*$').hasMatch(appStoreId),
      TargetPlatform.android => androidListingReady,
      _ => false,
    };
  }
}

enum RatingOutcome { openingRequested, notConfigured, failed, busy }

class GameRating {
  final RatingGateway gateway;
  final RatingConfiguration config;
  final TargetPlatform platform;
  bool _opening = false;
  GameRating({
    required this.gateway,
    required this.config,
    required this.platform,
  });
  bool get canOpen => config.canOpen(platform);

  Future<RatingOutcome> openListing() async {
    if (!canOpen) return RatingOutcome.notConfigured;
    if (_opening) return RatingOutcome.busy;
    _opening = true;
    try {
      // A button opens the store; the quota-controlled popup may silently fail.
      await gateway.openStoreListing(
        appStoreId: platform == TargetPlatform.iOS ? config.appStoreId : null,
      );
      // The platform cannot tell us whether the player actually left a review.
      return RatingOutcome.openingRequested;
    } catch (_) {
      return RatingOutcome.failed;
    } finally {
      _opening = false;
    }
  }
}

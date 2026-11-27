import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_flavor.dart';
import '../../core/services/game_rating.dart';

final gameRatingProvider = Provider<GameRating>(
  (ref) => GameRating(
    gateway: NativeRatingGateway(),
    config: RatingConfiguration(production: AppConfig.flavor.isProd),
    platform: defaultTargetPlatform,
  ),
);

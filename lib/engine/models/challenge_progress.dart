import '../content/challenge_catalog.dart';
import 'board.dart';

class ChallengeRules {
  static const nextLevelReward = 4;
  static int baseAllowance(Board board, ChallengeTier tier) =>
      board.par +
      switch (tier) {
        ChallengeTier.easy => 6,
        ChallengeTier.medium => 3,
        ChallengeTier.hard => 1,
      };
}

/// Session-only progress: a replay cannot farm bonus moves or stack grants.
class ChallengeProgress {
  final Set<String> _completed = {};
  final Map<String, int> _bonuses = {};
  int bonusFor(String levelId) => _bonuses[levelId] ?? 0;
  bool isCompleted(String id) => _completed.contains(id);
  int recordWin(ChallengeLevel level) {
    if (!_completed.add(level.id) || level.nextId == null) return 0;
    _bonuses[level.nextId!] = ChallengeRules.nextLevelReward;
    return ChallengeRules.nextLevelReward;
  }
}

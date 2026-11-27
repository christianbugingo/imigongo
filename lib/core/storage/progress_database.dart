import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'progress_database.g.dart';

class PuzzleScores extends Table {
  IntColumn get size => integer()();
  IntColumn get seed => integer()();
  IntColumn get version => integer()();
  IntColumn get stars => integer()();
  IntColumn get moves => integer()();
  @override
  Set<Column<Object>> get primaryKey => {size, seed, version};
}

class LevelWins extends Table {
  TextColumn get levelId => text()();
  TextColumn get nextId => text().nullable()();
  IntColumn get reward => integer()();
  @override
  Set<Column<Object>> get primaryKey => {levelId};
}

class ProgressSnapshot {
  final List<PuzzleScore> scores;
  final List<LevelWin> wins;
  const ProgressSnapshot({this.scores = const [], this.wins = const []});
}

@DriftDatabase(tables: [PuzzleScores, LevelWins])
class ProgressDatabase extends _$ProgressDatabase {
  ProgressDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'imigongo_progress'));
  int _generation = 0;
  int get generation => _generation;
  @override
  int get schemaVersion => 1;

  Future<ProgressSnapshot> load() => transaction(
    () async => ProgressSnapshot(
      scores: await select(puzzleScores).get(),
      wins: await select(levelWins).get(),
    ),
  );

  Future<void> saveWin({
    required int generation,
    required int size,
    required int seed,
    required int version,
    required int stars,
    required int moves,
    String? levelId,
    String? nextId,
    int reward = 0,
  }) => transaction(() async {
    // Reset invalidates queued writes from games started before the reset.
    if (generation != _generation) throw StateError('Progress was reset');
    final old =
        await (select(puzzleScores)..where(
              (r) =>
                  r.size.equals(size) &
                  r.seed.equals(seed) &
                  r.version.equals(version),
            ))
            .getSingleOrNull();
    await into(puzzleScores).insertOnConflictUpdate(
      PuzzleScore(
        size: size,
        seed: seed,
        version: version,
        stars: math.max(stars, old?.stars ?? 0),
        moves: math.min(moves, old?.moves ?? moves),
      ),
    );
    if (levelId != null) {
      await into(levelWins).insert(
        LevelWin(
          levelId: levelId,
          nextId: nextId,
          reward: nextId == null ? 0 : reward,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  Future<void> resetProgress() {
    _generation++;
    return transaction(() async {
      await delete(levelWins).go();
      await delete(puzzleScores).go();
    });
  }
}

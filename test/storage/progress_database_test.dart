import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/storage/progress_database.dart';

Future<void> win(
  ProgressDatabase db, {
  int moves = 12,
  int stars = 2,
  int? generation,
  String? level = 'easy-1',
}) => db.saveWin(
  generation: generation ?? db.generation,
  size: 3,
  seed: 17,
  version: 3,
  stars: stars,
  moves: moves,
  levelId: level,
  nextId: 'easy-2',
  reward: 4,
);
void main() {
  test(
    'file reopen restores scores and one bonus despite concurrent replay',
    () async {
      final directory = await Directory.systemTemp.createTemp('imigongo-test-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/progress.sqlite');
      var db = ProgressDatabase(NativeDatabase(file));
      await Future.wait([
        win(db),
        win(db, moves: 9, stars: 3),
        win(db, moves: 15, stars: 1),
      ]);
      await db.close();
      db = ProgressDatabase(NativeDatabase(file));
      addTearDown(db.close);
      final snapshot = await db.load();
      expect(snapshot.scores.single.moves, 9);
      expect(snapshot.scores.single.stars, 3);
      expect(snapshot.wins.single.reward, 4);
      await win(db);
      expect((await db.load()).wins, hasLength(1));
    },
  );
  test('reset clears both ledgers and rejects stale writes', () async {
    final db = ProgressDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final old = db.generation;
    await win(db);
    await db.resetProgress();
    await expectLater(win(db, generation: old), throwsStateError);
    expect((await db.load()).scores, isEmpty);
    expect((await db.load()).wins, isEmpty);
    await win(db);
    expect((await db.load()).wins.single.reward, 4);
  });
  test(
    'free play records scores without granting a challenge reward',
    () async {
      final db = ProgressDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await win(db, level: null);
      expect((await db.load()).scores, hasLength(1));
      expect((await db.load()).wins, isEmpty);
    },
  );
}

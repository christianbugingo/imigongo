import 'package:imigongo_pattern_puzzle/core/services/tutorial_preferences.dart';

class MemoryTutorialPreferences implements TutorialPreferences {
  bool finished;
  bool failReads = false, failWrites = false;
  MemoryTutorialPreferences({this.finished = false});
  @override
  Future<bool> readFinished() async {
    if (failReads) throw StateError('read failed');
    return finished;
  }

  @override
  Future<void> markFinished() async {
    if (failWrites) throw StateError('write failed');
    finished = true;
  }
}

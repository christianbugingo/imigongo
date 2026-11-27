import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'game_settings.dart';

enum GameCue { rotate, success, gameOver }

abstract class SoundOutput {
  Future<void> play(GameCue cue, double volume);
  Future<void> stop();
  Future<void> dispose();
}

class PlayerSoundOutput implements SoundOutput {
  final AudioPlayer _player = AudioPlayer();
  @override
  Future<void> play(GameCue cue, double volume) async {
    await _player.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
      ),
    );
    await _player.play(AssetSource('audio/${cue.name}.wav'), volume: volume);
  }

  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> dispose() => _player.dispose();
}

class GameEffects {
  final SoundOutput output;
  final GameSettings Function() settings;
  final Future<void> Function(GameCue) haptic;
  GameEffects(
    this.output,
    this.settings, {
    Future<void> Function(GameCue)? haptic,
  }) : haptic =
           haptic ??
           ((cue) => cue == GameCue.rotate
               ? HapticFeedback.selectionClick()
               : HapticFeedback.mediumImpact());
  Future<void> play(GameCue cue) async {
    final value = settings();
    // Device audio or haptic failures must not interrupt a move or a saved win.
    if (value.sound && value.volume > 0) {
      try {
        await output.play(cue, value.volume);
      } catch (_) {
        /* optional effect */
      }
    }
    if (value.haptics) {
      try {
        await haptic(cue);
      } catch (_) {
        /* optional effect */
      }
    }
  }
}

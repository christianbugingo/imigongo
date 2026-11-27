"""Original procedural cues, 22050 Hz mono PCM. No sampled recordings."""
import math
import pathlib
import struct
import wave

ROOT = pathlib.Path(__file__).resolve().parents[1] / 'assets' / 'audio'
ROOT.mkdir(parents=True, exist_ok=True)
for name, notes, duration in [('rotate', [650], .065),
                              ('success', [392, 494, 587], .48),
                              ('gameOver', [294, 220], .32)]:
    samples = []
    for i in range(round(22050 * duration)):
        t = i / 22050
        part = min(int(t / duration * len(notes)), len(notes) - 1)
        local = (t / duration * len(notes)) % 1
        envelope = math.sin(math.pi * local) ** 2
        samples.append(round(10000 * envelope * math.sin(2 * math.pi * notes[part] * t)))
    with wave.open(str(ROOT / f'{name}.wav'), 'wb') as audio:
        audio.setparams((1, 2, 22050, 0, 'NONE', 'not compressed'))
        audio.writeframes(struct.pack('<' + 'h' * len(samples), *samples))

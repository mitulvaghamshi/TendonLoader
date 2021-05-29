import 'package:audioplayers/audioplayers.dart' show AudioCache, AudioPlayer;

enum Clip { start, stop }

final AudioCache _clipPlayer = AudioCache(
  respectSilence: true,
  prefix: 'assets/audio/',
  fixedPlayer: AudioPlayer(playerId: 'tendonloader'),
);

void play(Clip clip) {
  switch (clip) {
    case Clip.start:
      _clipPlayer.play('start.mpeg');
      break;
    case Clip.stop:
      _clipPlayer.play('stop.mpeg');
      break;
  }
}

Future<void> load() async => _clipPlayer.loadAll(<String>['start.mpeg', 'stop.mpeg']);

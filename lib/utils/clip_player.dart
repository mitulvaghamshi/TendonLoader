import 'package:audioplayers/audioplayers.dart' show AudioCache, AudioPlayer;

const String _start = 'start.mpeg';
const String _stop = 'stop.mpeg';

final AudioCache _player = AudioCache(
  respectSilence: true,
  prefix: 'assets/audio/',
  fixedPlayer: AudioPlayer(playerId: 'tendonloader'),
);

void play(bool isStart, [double volume = 1.0]) => _player.play(isStart ? _start : _stop, volume: volume);

Future<void> load() async => _player.loadAll(<String>[_start, _stop]);

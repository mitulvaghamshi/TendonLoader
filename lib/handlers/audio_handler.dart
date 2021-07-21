import 'package:audioplayers/audioplayers.dart' show AudioCache, AudioPlayer;

final AudioPlayer _aPlayer = AudioPlayer(playerId: 'tendonloader');
final AudioCache _aCache = AudioCache(respectSilence: true, prefix: 'assets/audio/', fixedPlayer: _aPlayer);

const String _start = 'start.mpeg';
const String _stop = 'stop.mpeg';

Future<void> disposePlayer() async => _aPlayer.dispose();

Future<void> load() async => _aCache.loadAll(<String>[_start, _stop]);

void play(bool isStart, [double volume = 1.0]) => _aCache.play(isStart ? _start : _stop, volume: volume);

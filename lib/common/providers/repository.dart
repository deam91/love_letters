import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Direction { LEFT, RIGHT }

class GamePlay {
  GamePlay();
  List<int> _playersCount = [0, 0];
  Direction _pigeonDirection = Direction.RIGHT;

  void increment(int player) {
    final index = player == 1 ? 0 : 1;
    _playersCount[index]++;
  }

  void reset() {
    _playersCount = [0, 0];
  }

  set playersCount(List<int> value) {
    _playersCount = value;
  }

  List<int> get playersCount => _playersCount;

  Direction get pigeonDirection => _pigeonDirection;

  set pigeonDirection(Direction value) {
    _pigeonDirection = value;
  }
}

class GamePlayNotifier extends StateNotifier<GamePlay> {
  GamePlayNotifier() : super(GamePlay());
}

final gamePlayProvider = StateNotifierProvider<GamePlayNotifier, GamePlay>(
    (ref) => GamePlayNotifier());

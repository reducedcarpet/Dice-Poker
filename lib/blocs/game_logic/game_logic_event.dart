part of 'game_logic_bloc.dart';

@immutable
abstract class GameLogicEvent extends Equatable {
  final List<bool> keep;
  final int x;
  final int index;
  final Score score;

  GameLogicEvent(this.keep, this.x, this.index, this.score);

  @override
  List<Object> get props => [keep];
}

class RollTurn extends GameLogicEvent {
  RollTurn() : super([false, false, false, false, false], -2, -2, null);

  RollTurn.withKeepers(List<bool> keepers) : super(keepers, -2, -2, null);
}

class KeepRollTurn extends GameLogicEvent {
  KeepRollTurn() : super([false, false, false, false, false], -2, -2, null);
}

class ScoreTurn extends GameLogicEvent {
  ScoreTurn() : super([false, false, false, false, false], -2, -2, null);
}

class PlaceScore extends GameLogicEvent {
  final bool firstScore;
  PlaceScore(int x, int y, Score score, this.firstScore) : super([false, false, false, false, false], x, y, score);
}

class NextTurn extends GameLogicEvent {
  NextTurn() : super([false, false, false, false, false], -2, -2, null);
}

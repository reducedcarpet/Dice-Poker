part of 'game_logic_bloc.dart';

@immutable
abstract class GameLogicEvent extends Equatable {
  final List<bool> keep;

  GameLogicEvent(this.keep);

  @override
  List<Object> get props => [keep];
}

class RollTurn extends GameLogicEvent {
  RollTurn() : super([false, false, false, false, false]);

  RollTurn.withKeepers(List<bool> keepers) : super(keepers);
}

class KeepRollTurn extends GameLogicEvent {
  KeepRollTurn() : super([false, false, false, false, false]);
}

class ScoreTurn extends GameLogicEvent {
  ScoreTurn() : super([false, false, false, false, false]);
}

class NextTurn extends GameLogicEvent {
  NextTurn() : super([false, false, false, false, false]);
}

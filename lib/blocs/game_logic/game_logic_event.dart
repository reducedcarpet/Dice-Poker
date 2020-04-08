part of 'game_logic_bloc.dart';

@immutable
abstract class GameLogicEvent {
  bool keepChange = false;
  bool roll = false;
  bool score = false;

  bool serve = false;
  List<bool> keep = [false, false, false, false, false];
}

class RollTurn extends GameLogicEvent {}

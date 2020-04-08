import 'package:dice_poker/models/game_turn.dart';
import 'package:dice_poker/models/roll.dart';
import 'package:dice_poker/models/scorecard.dart';

class GameState {
  int currentTurn = 0;
  Roll currentRoll;
  int currentRollNumber = 0;
  List<Roll> currentRolls = [];

  List<GameTurn> turns = [];
  Scorecard scorecard;

  GameState({this.currentTurn, this.currentRoll, this.currentRollNumber, this.currentRolls, this.turns, this.scorecard});

  factory GameState.initial() {
    return GameState();
  }
}

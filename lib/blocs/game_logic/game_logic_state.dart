part of 'game_logic_bloc.dart';

@immutable
abstract class GameLogicState extends Equatable {
  final int currentTurn;
  final Roll currentRoll;
  final int currentRollNumber;
  final List<Roll> currentRolls;
  final bool scoring;
  final String pokerName;

  final List<GameTurn> turns;
  final Scorecard scorecard;

  GameLogicState(this.currentTurn, this.currentRolls, this.currentRoll, this.currentRollNumber, this.turns, this.scorecard,
      {this.scoring, this.pokerName, List<dynamic> props = const <dynamic>[]})
      : super();

  @override
  List<Object> get props => [currentTurn, currentRoll, currentRolls, currentRollNumber, turns, scorecard];
}

class InitialGameLogicState extends GameLogicState {
  InitialGameLogicState() : super(0, [], Roll(), 0, [], Scorecard(), scoring: false, pokerName: '');
}

class NextRoll extends GameLogicState {
  NextRoll(currentTurn, currentRoll, currentRollNumber, currentRolls, turns, scorecard)
      : super(currentTurn, currentRolls, currentRoll, currentRollNumber, turns, scorecard, scoring: false, pokerName: '');
}

class ScoringRoll extends GameLogicState {
  ScoringRoll(currentTurn, currentRoll, currentRollNumber, currentRolls, turns, scorecard, scoring, pokerName)
      : super(currentTurn, currentRolls, currentRoll, currentRollNumber, turns, scorecard, scoring: scoring, pokerName: pokerName);
}

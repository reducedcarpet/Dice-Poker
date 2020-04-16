part of 'game_logic_bloc.dart';

@immutable
abstract class GameLogicState extends Equatable {
  final int currentTurn;
  final int currentRollNumber;

  final Roll firstRoll;
  final Roll secondRoll;

  final List<Roll> currentRolls;
  final bool scoring;
  final String pokerName;
  final List<Score> scoreMatrixFirst;
  final List<Score> scoreMatrixSecond;

  final List<GameTurn> turns;
  final Scorecard scorecard;

  final List<List<ScoreItem>> data;

  GameLogicState(this.currentTurn, this.currentRolls, this.firstRoll, this.secondRoll, this.currentRollNumber, this.turns, this.scorecard, this.data,
      {this.scoring, this.pokerName, this.scoreMatrixFirst, this.scoreMatrixSecond})
      : super();

  @override
  List<Object> get props => [currentTurn, firstRoll, currentRolls, currentRollNumber, turns, scorecard];
}

class InitialGameLogicState extends GameLogicState {
  InitialGameLogicState(List<List<ScoreItem>> data) : super(0, [], Roll(), Roll(), 0, [], Scorecard(), data, scoring: false, pokerName: '');
}

class NextRoll extends GameLogicState {
  NextRoll(currentTurn, currentRoll, secondRoll, currentRollNumber, currentRolls, turns, scorecard, data, {scoreMatrixFirst, scoreMatrixSecond})
      : super(currentTurn, currentRolls, currentRoll, secondRoll, currentRollNumber, turns, scorecard, data,
            scoring: false, pokerName: '', scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);

  NextRoll.scoringRoll(currentTurn, currentRoll, secondRoll, currentRollNumber, currentRolls, turns, scorecard, data, scoring, pokerName,
      {scoreMatrixFirst, scoreMatrixSecond})
      : super(currentTurn, currentRolls, currentRoll, secondRoll, currentRollNumber, turns, scorecard, data,
            scoring: scoring, pokerName: pokerName, scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);

  NextRoll.finalRoll(currentTurn, currentRollNumber, currentRoll, secondRoll, turns, scorecard, data, scoring, pokerName, scoreMatrixFirst, scoreMatrixSecond)
      : super(currentTurn, [], currentRoll, secondRoll, currentRollNumber, turns, scorecard, data,
            scoring: scoring, pokerName: pokerName, scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);

  NextRoll.newTurn(currentTurn, turns, scorecard, data)
      : super(currentTurn, [], Roll(), Roll(), 0, turns, scorecard, data, scoring: false, pokerName: '', scoreMatrixFirst: [], scoreMatrixSecond: []);

  @override
  List<Object> get props => [currentTurn, firstRoll, currentRolls, currentRollNumber, turns, scorecard];
}

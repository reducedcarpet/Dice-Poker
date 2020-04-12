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

  GameLogicState(this.currentTurn, this.currentRolls, this.firstRoll, this.secondRoll, this.currentRollNumber, this.turns, this.scorecard,
      {this.scoring, this.pokerName, this.scoreMatrixFirst, this.scoreMatrixSecond})
      : super();

  @override
  List<Object> get props => [currentTurn, firstRoll, currentRolls, currentRollNumber, turns, scorecard];
}

class InitialGameLogicState extends GameLogicState {
  InitialGameLogicState() : super(0, [], Roll(), Roll(), 0, [], Scorecard(), scoring: false, pokerName: '');
}

class NextRoll extends GameLogicState {
  NextRoll(currentTurn, currentRoll, secondRoll, currentRollNumber, currentRolls, turns, scorecard)
      : super(currentTurn, currentRolls, currentRoll, secondRoll, currentRollNumber, turns, scorecard, scoring: false, pokerName: '');

  NextRoll.scoringRoll(currentTurn, currentRoll, secondRoll, currentRollNumber, currentRolls, turns, scorecard, scoring, pokerName)
      : super(currentTurn, currentRolls, currentRoll, secondRoll, currentRollNumber, turns, scorecard, scoring: scoring, pokerName: pokerName);

  NextRoll.finalRoll(currentTurn, currentRollNumber, currentRoll, secondRoll, turns, scorecard, scoring, pokerName, scoreMatrixFirst, scoreMatrixSecond)
      : super(currentTurn, [], currentRoll, secondRoll, currentRollNumber, turns, scorecard,
            scoring: scoring, pokerName: pokerName, scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);

  NextRoll.newTurn(currentTurn, turns, scorecard)
      : super(currentTurn, [], Roll(), Roll(), 0, turns, scorecard, scoring: false, pokerName: '', scoreMatrixFirst: [], scoreMatrixSecond: []);

  @override
  List<Object> get props => [currentTurn, firstRoll, currentRolls, currentRollNumber, turns, scorecard];
}

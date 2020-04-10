import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dice_poker/models/game_turn.dart';
import 'package:dice_poker/models/roll.dart';
import 'package:dice_poker/models/score.dart';
import 'package:dice_poker/models/scorecard.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_logic_event.dart';
part 'game_logic_state.dart';

class GameLogicBloc extends Bloc<GameLogicEvent, GameLogicState> {
  @override
  GameLogicState get initialState => InitialGameLogicState();

  @override
  Stream<GameLogicState> mapEventToState(GameLogicEvent event) async* {
    if (event is NextTurn) {
      List<GameTurn> turns = List.from(state.turns);
      turns.add(GameTurn(state.currentRolls));
      int newTurn = state.currentTurn + 1;
      yield NextRoll.newTurn(newTurn, turns, state.scorecard);
    } else if (event is KeepRollTurn) {
      print('keep turn');
      Roll curr = state.currentRolls[state.currentRollNumber - 1];
      print('Skip rolls...');
      List<Roll> rolls = List.from(state.currentRolls);

      for (int i = 0; i < 3; i++) {
        if (rolls.length < 3) rolls.add(curr);
      }

      print('Skip roll');

      yield NextRoll(state.currentTurn, curr, Roll(), 3, rolls, state.turns, state.scorecard);
    } else if (event is ScoreTurn) {
      List<GameTurn> turns = List.from(state.turns);
      turns.add(GameTurn(state.currentRolls));
      int newTurn = state.currentTurn + 1;
      Roll curr = state.currentRolls[state.currentRolls.length - 1];
      Roll first = state.currentRolls[2];
      List<Score> scoreMatrix = generateScores('1st Roll: ', first.roll);
      scoreMatrix.addAll(generateScores('2nd Roll: ', curr.roll));

      print('score matrix: ' + scoreMatrix.toString());

      yield NextRoll.finalRoll(newTurn, turns, state.scorecard, true, '', scoreMatrix);
    } else if (event is RollTurn) {
      /* if (state.currentRollNumber == 2) {
        // last roll of this section

        Roll curr = Roll.randomKeep(event.keep, state.currentRolls[state.currentRollNumber - 1]);
        List<Roll> rolls = List.from(state.currentRolls);
        rolls.add(curr);

        Map<String, int> scoreMatrix = generateScores(curr.roll);
        print('final roll: ' + scoreMatrix.toString());
        yield NextRoll.finalRoll(state.currentTurn, curr, Roll(), state.currentRollNumber + 1, rolls, state.turns, state.scorecard, scoreMatrix[scoreMatrix.keys.toList()[0]],
            scoreMatrix.keys.toList()[0], scoreMatrix);
      }
      else // */
      if (state.currentRollNumber > 0) {
        // not the first roll
        Roll curr = Roll.randomKeep(event.keep, state.currentRolls[state.currentRollNumber - 1]);
        List<Roll> rolls = List.from(state.currentRolls);
        rolls.add(curr);
        Roll second = Roll();
        Score sc;

        if (state.currentRollNumber > 2) {
          // we are on the second set of rolls
          second = curr;
          curr = state.currentRolls[2];
          sc = checkForScore(second.roll);
        } else {
          sc = checkForScore(curr.roll);
        }

        if (sc.scoring) {
          String serve = '';
          if (!event.keep.contains(true)) serve = 'Served: ';
          yield NextRoll.scoringRoll(
              state.currentTurn, curr, second, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, sc.scoring, serve + sc.name.toString());
        } else
          yield NextRoll(state.currentTurn, curr, second, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      } else if (state.currentRollNumber == 0) {
        // first roll, so no history to keep dice from
        Roll curr = Roll.random();
        List<Roll> rolls = [curr];

        Score sc = checkForScore(curr.roll);
        if (sc.scoring) {
          String serve = '';
          if (!event.keep.contains(true)) serve = 'Served: ';
          yield NextRoll.scoringRoll(
              state.currentTurn, curr, Roll(), state.currentRollNumber + 1, rolls, state.turns, state.scorecard, sc.scoring, serve + sc.name.toString());
        } else
          yield NextRoll(state.currentTurn, curr, Roll(), state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      }
    }
  }

  List<Score> generateScores(String prefix, List<String> roll) {
    List<Score> res = [];

    Score sc = checkForScore(roll);
    if (sc.scoring) res.add(sc);

    List<String> allA = List.from(roll.where((element) => element == 'A'));
    if (allA.isNotEmpty) {
      Score result = Score(true, (_score(allA[0]) * allA.length), 'Aces', 5);
      res.add(result);
    }

    List<String> allK = List.from(roll.where((element) => element == 'K'));
    if (allK.isNotEmpty) {
      Score result = Score(true, (_score(allK[0]) * allK.length), 'Kings', 4);
      res.add(result);
    }

    List<String> allQ = List.from(roll.where((element) => element == 'Q'));
    if (allQ.isNotEmpty) {
      Score result = Score(true, (_score(allQ[0]) * allQ.length), 'Queens', 3);
      res.add(result);
    }

    List<String> allJ = List.from(roll.where((element) => element == 'J'));
    if (allJ.isNotEmpty) {
      Score result = Score(true, (_score(allJ[0]) * allJ.length), 'Jacks', 2);
      res.add(result);
    }

    List<String> allTen = List.from(roll.where((element) => element == '10'));
    if (allTen.isNotEmpty) {
      Score result = Score(true, (_score(allTen[0]) * allTen.length), 'Tens', 1);
      res.add(result);
    }

    List<String> allNine = List.from(roll.where((element) => element == '9'));
    if (allNine.isNotEmpty) {
      Score result = Score(true, (_score(allNine[0]) * allNine.length), 'Nines', 0);
      res.add(result);
    }

    return res;
  }

  Score checkForScore(List<String> roll) {
    if (roll.contains('A') && roll.contains('K') && roll.contains('Q') && roll.contains('J') && roll.contains('10')) {
      // big street
      Score result = Score(true, 25, 'Big Street', 7);
      return result;
    } else if (roll.contains('K') && roll.contains('Q') && roll.contains('J') && roll.contains('10') && roll.contains('9')) {
      // small street
      Score result = Score(true, 20, 'Small Street', 7);
      return result;
    } else if (roll[0] == roll[1] && roll[1] == roll[2] && roll[2] == roll[3] && roll[3] == roll[4]) {
      // grand
      Score result = Score(true, 50 + (_score(roll[0]) * 5), _name(roll[0]) + ' Grand', 10);
      return result;
    } else {
      List<String> allA = List.from(roll.where((element) => element == 'A'));
      if (allA.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allA[0]) * 4), 'Ace Poker', 9);
        return result;
      } else if (allA.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allA);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }

      List<String> allK = List.from(roll.where((element) => element == 'K'));
      if (allK.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allK[0]) * 4), 'King Poker', 9);
        return result;
      } else if (allK.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allK);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }

      List<String> allQ = List.from(roll.where((element) => element == 'Q'));
      if (allQ.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allQ[0]) * 4), 'Queen Poker', 9);
        return result;
      } else if (allQ.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allQ);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }

      List<String> allJ = List.from(roll.where((element) => element == 'J'));
      if (allJ.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allJ[0]) * 4), 'Jack Poker', 9);
        return result;
      } else if (allJ.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allJ);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }

      List<String> allTen = List.from(roll.where((element) => element == '10'));
      if (allTen.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allTen[0]) * 4), 'Ten Poker', 9);
        return result;
      } else if (allTen.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allTen);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }

      List<String> allNine = List.from(roll.where((element) => element == '9'));
      if (allNine.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allNine[0]) * 4), 'Nine Poker', 9);
        return result;
      } else if (allNine.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allNine);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }
    }

    Score result = Score(false, 0, '', -1);
    return result;
  }

  Score checkFullHouse(List<String> roll, List<String> allA) {
    List<String> others = List.from(roll.where((element) => element != allA[0]));
    if (others[0] == others[1]) {
      // Full House
      Score result = Score(true, 30 + (_score(allA[0]) * 3), 'Full House - ' + _name(allA[0]) + 's over ' + _name(others[0]) + 's', 8);
      return result;
    } else
      return Score(false, 0, '', -1);
  }

  int _score(String die) {
    if (die == 'A') return 6;
    if (die == 'K') return 5;
    if (die == 'Q') return 4;
    if (die == 'J') return 3;
    if (die == '10') return 2;
    if (die == '9') return 1;
    return 0;
  }

  String _name(String die) {
    if (die == 'A') return 'Ace';
    if (die == 'K') return 'King';
    if (die == 'Q') return 'Queen';
    if (die == 'J') return 'Jack';
    if (die == '10') return 'Ten';
    if (die == '9') return 'Nine';
    return '';
  }
}

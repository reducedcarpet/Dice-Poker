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
    if (event is RollTurn) {
      if (state.currentRollNumber > 0) {
        Roll curr = Roll.randomKeep(event.keep, state.currentRolls[state.currentRollNumber - 1]);
        List<Roll> rolls = List.from(state.currentRolls);
        rolls.add(curr);

        Score sc = checkForScore(curr.roll);
        if (sc.scoring) {
          yield ScoringRoll(
              state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, sc.scoring, 'Served: ' + sc.name.toString());
        } else
          yield NextRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      } else {
        Roll curr = Roll.random();
        List<Roll> rolls = [curr];

        Score sc = checkForScore(curr.roll);
        if (sc.scoring) {
          yield ScoringRoll(
              state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, sc.scoring, 'Served: ' + sc.name.toString());
        } else
          yield NextRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      }
    }

    if (event is RollTurnWithKeepers) {
      if (state.currentRollNumber > 0) {
        // This should always be the case, can't keep dice if you haven't rolled anything yet.
        Roll curr = Roll.randomKeep(event.keep, state.currentRolls[state.currentRollNumber - 1]);
        List<Roll> rolls = List.from(state.currentRolls);
        rolls.add(curr);

        Score sc = checkForScore(curr.roll);
        if (sc.scoring) {
          String serve = '';
          if (!event.keep.contains(true)) serve = 'Served: ';
          yield ScoringRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, sc.scoring, serve + sc.name.toString());
        } else
          yield NextRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      }
    }
  }

  Score checkForScore(List<String> roll) {
    if (roll.contains('A') && roll.contains('K') && roll.contains('Q') && roll.contains('J') && roll.contains('10')) {
      // big street
      Score result = Score(true, 25, 'Big Street');
      return result;
    } else if (roll.contains('K') && roll.contains('Q') && roll.contains('J') && roll.contains('10') && roll.contains('9')) {
      // small street
      Score result = Score(true, 20, 'Small Street');
      return result;
    } else if (roll[0] == roll[1] && roll[1] == roll[2] && roll[2] == roll[3] && roll[3] == roll[4]) {
      // grand
      Score result = Score(true, 50 + (_score(roll[0]) * 5), _name(roll[0]) + ' Grand');
      return result;
    } else {
      List<String> allA = List.from(roll.where((element) => element == 'A'));
      if (allA.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allA[0]) * 4), 'Ace Poker');
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
        Score result = Score(true, 40 + (_score(allK[0]) * 4), 'King Poker');
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
        Score result = Score(true, 40 + (_score(allQ[0]) * 4), 'Queen Poker');
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
        Score result = Score(true, 40 + (_score(allJ[0]) * 4), 'Jack Poker');
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
        Score result = Score(true, 40 + (_score(allTen[0]) * 4), 'Ten Poker');
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
        Score result = Score(true, 40 + (_score(allNine[0]) * 4), 'Nine Poker');
        return result;
      } else if (allNine.length == 3) {
        // Possible Full House
        Score result = checkFullHouse(roll, allNine);
        if (result.scoring) return result;
        // else not a full house, continue on to oblivion.
      }
    }

    Score result = Score(false, 0, '');
    return result;
  }

  Score checkFullHouse(List<String> roll, List<String> allA) {
    List<String> others = List.from(roll.where((element) => element != allA[0]));
    if (others[0] == others[1]) {
      // Full House
      Score result = Score(true, 30 + (_score(allA[0]) * 3), 'Full House - ' + _name(allA[0]) + 's over ' + _name(others[0]) + 's');
      return result;
    } else
      return Score(false, 0, '');
  }

  int _score(String die) {
    if (die == 'A') return 6;
    if (die == 'K') return 5;
    if (die == 'Q') return 4;
    if (die == 'J') return 3;
    if (die == '10') return 2;
    if (die == '9') return 1;
  }

  String _name(String die) {
    if (die == 'A') return 'Ace';
    if (die == 'K') return 'King';
    if (die == 'Q') return 'Queen';
    if (die == 'J') return 'Jack';
    if (die == '10') return 'Ten';
    if (die == '9') return 'Nine';
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dice_poker/models/ScoreItem.dart';
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
  GameLogicState get initialState {
    return InitialGameLogicState(_initData(Scorecard(), [], []));
  }

  @override
  Stream<GameLogicState> mapEventToState(GameLogicEvent event) async* {
    if (event is PlaceScore) {
      yield handlePlaceScore(event);
    } else if (event is NextTurn) {
      yield handleNextTurn();
    } else if (event is KeepRollTurn) {
      yield handleKeepRollTurn();
    } else if (event is ScoreTurn) {
      yield handleScoreTurn();
    } else if (event is RollTurn) {
      yield handleRollTurn(event);
    }
  }

  /////////////////////////////////////////////////////////////////////
  // Event Handlers
  /////////////////////////////////////////////////////////////////////

  GameLogicState handlePlaceScore(PlaceScore event) {
    Scorecard scs = state.scorecard;
    if (event.x == 0) {
      scs.down[event.index] = event.score.score;
    } else if (event.x == 1) {
      scs.up[event.index] = event.score.score;
    } else if (event.x == 2) {
      scs.any[event.index] = event.score.score;
    }

    print('First: ' + state.scoreMatrixFirst.toString() + " first: " + event.firstScore.toString());
    print('Second: ' + state.scoreMatrixSecond.toString());

    List<List<ScoreItem>> data = _initData(scs, state.scoreMatrixFirst, state.scoreMatrixSecond);

    if (state.scoreMatrixSecond.isEmpty && state.scoreMatrixFirst.isEmpty) {
      List<GameTurn> turns = List.from(state.turns);
      turns.add(GameTurn(state.currentRolls));
      int newTurn = state.currentTurn + 1;
      print('Next turn 1');
      return NextRoll.newTurn(newTurn, turns, scs, data);
    } else if (event.firstScore && state.scoreMatrixSecond.isNotEmpty) {
      print('Chose first roll');
      return NextRoll.finalRoll(
          state.currentTurn, state.currentRollNumber, state.firstRoll, state.secondRoll, state.turns, scs, data, true, '', [], state.scoreMatrixSecond);
    } else if (!event.firstScore && state.scoreMatrixFirst.isNotEmpty) {
      print('Chose second roll ' + state.scoreMatrixFirst.toString());
      return NextRoll.finalRoll(
          state.currentTurn, state.currentRollNumber, state.firstRoll, state.secondRoll, state.turns, scs, data, true, '', state.scoreMatrixFirst, []);
    } else {
      print('next turn 2');
      List<GameTurn> turns = List.from(state.turns);
      turns.add(GameTurn(state.currentRolls));
      int newTurn = state.currentTurn + 1;
      return NextRoll.newTurn(newTurn, turns, scs, data);
    }
  }

  GameLogicState handleNextTurn() {
    List<GameTurn> turns = List.from(state.turns);
    turns.add(GameTurn(state.currentRolls));
    int newTurn = state.currentTurn + 1;
    List<List<ScoreItem>> data = _initData(state.scorecard, [], []);

    return NextRoll.newTurn(newTurn, turns, state.scorecard, data);
  }

  GameLogicState handleKeepRollTurn() {
    Roll curr = state.currentRolls[state.currentRollNumber - 1];
    List<Roll> rolls = List.from(state.currentRolls);

    for (int i = 0; i < 3; i++) {
      if (rolls.length < 3) rolls.add(curr);
    }

    List<Score> scoreMatrixFirst = state.scoreMatrixFirst;
    List<Score> scoreMatrixSecond = state.scoreMatrixSecond;

    // TODO add keeping of served rolls here.
    // Score result = Score(true, 10 + (_score(roll[0]) * 5), state.pokerName, 11);

    return NextRoll(state.currentTurn, curr, Roll(), 3, rolls, state.turns, state.scorecard, state.data,
        scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);
  }

  GameLogicState handleScoreTurn() {
    // check for the middle lane of +30 points if you get over 60 in the top section, if it's a upwards column, just skip it till the end.
    Roll curr = state.currentRolls[state.currentRolls.length - 1];
    Roll first = state.currentRolls[2];
    List<Score> scoreMatrixFirst = state.scoreMatrixFirst;
    List<Score> scoreMatrixSecond = state.scoreMatrixSecond;
    scoreMatrixFirst.addAll(generateScores('1st Roll: ', first.roll));
    scoreMatrixSecond.addAll(generateScores('2nd Roll: ', curr.roll));
    List<List<ScoreItem>> data = _initData(state.scorecard, scoreMatrixFirst, scoreMatrixSecond);

    return NextRoll.finalRoll(state.currentTurn, state.currentRollNumber, state.firstRoll, state.secondRoll, state.turns, state.scorecard, data, true, '',
        scoreMatrixFirst, scoreMatrixSecond);
  }

  GameLogicState handleRollTurn(RollTurn event) {
    if (state.currentRollNumber > 0) {
      // not the first roll
      Roll curr = Roll.randomKeep(event.keep, state.currentRolls[state.currentRollNumber - 1]);
      List<Roll> rolls = List.from(state.currentRolls);
      rolls.add(curr);
      Roll second = Roll();
      Score sc;
      bool firstRound = true;

      if (state.currentRollNumber > 2) {
        // we are on the second set of rolls
        second = curr;
        firstRound = false;
        curr = state.currentRolls[2];
        sc = checkForScore(second.roll);
      } else {
        sc = checkForScore(curr.roll);
      }

      List<Score> scoreMatrixFirst = state.scoreMatrixFirst;
      List<Score> scoreMatrixSecond = state.scoreMatrixSecond;

      if (sc.scoring) {
        String serve = '';
        if (!event.keep.contains(true)) serve = 'Served: ';

        if (firstRound)
          scoreMatrixFirst = [Score(true, sc.score + servePoints, serve + sc.name.toString(), 11)];
        else
          scoreMatrixSecond = [Score(true, sc.score + servePoints, serve + sc.name.toString(), 11)];

        return NextRoll.scoringRoll(state.currentTurn, curr, second, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, state.data, sc.scoring,
            serve + sc.name.toString(),
            scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);
      } else
        return NextRoll(state.currentTurn, curr, second, state.currentRollNumber + 1, rolls, state.turns, state.scorecard, state.data,
            scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);
    } else if (state.currentRollNumber == 0) {
      // first roll, so no history to keep dice from
      Roll curr = Roll.random();
      List<Roll> rolls = [curr];

      List<Score> scoreMatrixFirst = [];
      List<Score> scoreMatrixSecond = [];

      Score sc = checkForScore(curr.roll);
      if (sc.scoring) {
        String serve = '';
        scoreMatrixFirst = [Score(true, sc.score + servePoints, serve + sc.name.toString(), 11)];
        if (!event.keep.contains(true)) serve = 'Served: ';
        return NextRoll.scoringRoll(state.currentTurn, curr, Roll(), state.currentRollNumber + 1, rolls, state.turns, state.scorecard, state.data, sc.scoring,
            serve + sc.name.toString(),
            scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);
      } else
        return NextRoll(state.currentTurn, curr, Roll(), state.currentRollNumber + 1, rolls, state.turns, state.scorecard, state.data,
            scoreMatrixFirst: scoreMatrixFirst, scoreMatrixSecond: scoreMatrixSecond);
    }
  }

  /////////////////////////////////////////////////////////////////////
  // scoring functions
  /////////////////////////////////////////////////////////////////////

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
      Score result = Score(true, 25, 'Big Street', 6);
      return result;
    } else if (roll.contains('K') && roll.contains('Q') && roll.contains('J') && roll.contains('10') && roll.contains('9')) {
      // small street
      Score result = Score(true, 20, 'Small Street', 6);
      return result;
    } else if (roll[0] == roll[1] && roll[1] == roll[2] && roll[2] == roll[3] && roll[3] == roll[4]) {
      // grand
      Score result = Score(true, 50 + (_score(roll[0]) * 5), _name(roll[0]) + ' Grand', 9);
      return result;
    } else {
      List<String> allA = List.from(roll.where((element) => element == 'A'));
      if (allA.length == 4) {
        // Poker
        Score result = Score(true, 40 + (_score(allA[0]) * 4), 'Ace Poker', 8);
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
        Score result = Score(true, 40 + (_score(allK[0]) * 4), 'King Poker', 8);
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
        Score result = Score(true, 40 + (_score(allQ[0]) * 4), 'Queen Poker', 8);
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
        Score result = Score(true, 40 + (_score(allJ[0]) * 4), 'Jack Poker', 8);
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
        Score result = Score(true, 40 + (_score(allTen[0]) * 4), 'Ten Poker', 8);
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
        Score result = Score(true, 40 + (_score(allNine[0]) * 4), 'Nine Poker', 8);
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
      Score result = Score(true, 30 + (_score(allA[0]) * 3), 'Full House - ' + _name(allA[0]) + 's over ' + _name(others[0]) + 's', 7);
      return result;
    } else
      return Score(false, 0, '', -1);
  }

  List<List<ScoreItem>> _initData(Scorecard scorecard, List<Score> scoreMatrixFirst, List<Score> scoreMatrixSecond) {
    if (scoreMatrixFirst != null || scoreMatrixSecond != null)
      scoreMatrixFirst.forEach((sc) => print("1st: Score: " + sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));
    if (scoreMatrixSecond != null || scoreMatrixSecond != null)
      scoreMatrixFirst.forEach((sc) => print("2nd: Score: " + sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));

    List<List<ScoreItem>> result = [];
    List<ScoreItem> down = [];
    int index = 0;
    for (int i in scorecard.down) {
      bool poss = false;
      if ((scoreMatrixFirst != null && scoreMatrixFirst.isNotEmpty) || (scoreMatrixSecond != null && scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);
        if (sco1 != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index > 0 && scorecard.down[index - 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == 0 && i == 0) poss = true;

          if (poss) down.add(ScoreItem(i != 0, sco1.score, poss, 0, index, true));
        }

        if (sco2 != null) {
          if (index > 0 && scorecard.down[index - 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == 0 && i == 0) poss = true;
          if (poss) down.add(ScoreItem(i != 0, sco2.score, poss, 0, index, false));
        }
      }
      if (!poss) down.add(ScoreItem(i != 0, i, poss, 0, index, false));

      index++;
    }

    result.add(down);

    List<ScoreItem> up = [];
    index = 0;
    for (int i in scorecard.up) {
      bool poss = false;
      if ((scoreMatrixFirst != null && scoreMatrixFirst.isNotEmpty) || (scoreMatrixSecond != null && scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);

        if (sco1 != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index < scorecard.up.length - 1 && scorecard.up[index + 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == scorecard.down.length - 1 && i == 0) poss = true;

          if (poss) up.add(ScoreItem(i != 0, sco1.score, poss, 1, index, true));
        }

        if (sco2 != null) {
          if (index < scorecard.up.length - 1 && scorecard.up[index + 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == scorecard.down.length - 1 && i == 0) poss = true;

          if (poss) up.add(ScoreItem(i != 0, sco2.score, poss, 1, index, false));
        }
      }

      if (!poss) up.add(ScoreItem(i != 0, i, poss, 1, index, false));
      index++;
    }

    result.add(up);

    List<ScoreItem> any = [];
    index = 0;
    for (int i in scorecard.any) {
      bool poss = false;
      if ((scoreMatrixFirst != null && scoreMatrixFirst.isNotEmpty) || (scoreMatrixSecond != null && scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);
        //scoreMatrix.forEach((sc) => print(sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));
        if (sco1 != null) {
          // Something has been found!
          if (i == 0) {
            poss = true;
            any.add(ScoreItem(i != 0, sco1.score, poss, 2, index, true));
          }
        }

        if (sco2 != null) {
          // Something has been found!
          if (i == 0) {
            poss = true;
            any.add(ScoreItem(i != 0, sco2.score, poss, 2, index, false));
          }
        }
      }

      if (!poss) any.add(ScoreItem(i != 0, i, poss, 2, index, false));
      index++;
    }

    result.add(any);

    return result;
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

  final servePoints = 10;
}

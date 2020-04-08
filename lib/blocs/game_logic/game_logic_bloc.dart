import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dice_poker/models/game_turn.dart';
import 'package:dice_poker/models/roll.dart';
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
        yield NextRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      } else {
        Roll curr = Roll.random();
        List<Roll> rolls = [curr];
        yield NextRoll(state.currentTurn, curr, state.currentRollNumber + 1, rolls, state.turns, state.scorecard);
      }
    }
  }
}

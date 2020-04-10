import 'package:dice_poker/models/roll.dart';
import 'package:equatable/equatable.dart';

final int servePoints = 10;

class GameTurn extends Equatable {
  final List<Roll> rolls;
  //int scoreOne = 0;
  //int scoreTwo = 0;

  GameTurn(this.rolls);

  @override
  List<Object> get props => [rolls];
}

import 'package:dice_poker/models/roll.dart';

final int servePoints = 10;

class GameTurn {
  bool keepChange = false;
  bool roll = false;
  bool score = false;

  bool serve = false;
  List<bool> keep = [false, false, false, false, false];
  List<Roll> rolls = [];
  int scoreOne = 0;
  int scoreTwo = 0;
}

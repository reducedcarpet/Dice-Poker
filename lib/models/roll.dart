import 'dart:math';

class Roll {
  List<String> roll = [];

  Roll();

  Roll.random() {
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
  }

  Roll.randomKeep(List<bool> keep, Roll previous) {
    if (!keep[0])
      roll.add(getChar(rnd.nextInt(6)));
    else
      roll.add(previous.roll[0]);
    if (!keep[1])
      roll.add(getChar(rnd.nextInt(6)));
    else
      roll.add(previous.roll[1]);
    if (!keep[2])
      roll.add(getChar(rnd.nextInt(6)));
    else
      roll.add(previous.roll[2]);
    if (!keep[3])
      roll.add(getChar(rnd.nextInt(6)));
    else
      roll.add(previous.roll[3]);
    if (!keep[4])
      roll.add(getChar(rnd.nextInt(6)));
    else
      roll.add(previous.roll[4]);
  }

  Random rnd = Random(DateTime.now().millisecondsSinceEpoch);

  String getChar(int n) {
    if (n == 0)
      return '9';
    else if (n == 1)
      return '10';
    else if (n == 2)
      return 'J';
    else if (n == 3)
      return 'Q';
    else if (n == 4)
      return 'K';
    else
      return 'A';
  }
}

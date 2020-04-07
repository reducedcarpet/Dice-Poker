import 'dart:math';

import 'package:dice_poker/widgets/dice.dart';
import 'package:flutter/material.dart';

class Roll extends StatefulWidget {
  Roll({Key key}) : super(key: key);

  @override
  _RollState createState() {
    return _RollState();
  }
}

class _RollState extends State<Roll> {
  @override
  void initState() {
    super.initState();
    randomRoll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> roll = [];
  Random rnd = Random(DateTime.now().millisecondsSinceEpoch);

  void randomRoll() {
    roll = [];
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
    roll.add(getChar(rnd.nextInt(6)));
  }

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Dice(roll[0]),
        Dice(roll[1]),
        Dice(roll[2]),
        Dice(roll[3]),
        Dice(roll[4]),
        MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              randomRoll();
            });
          },
          child: Container(
            child: Text('Roll'),
          ),
        ),
      ],
    );
  }
}

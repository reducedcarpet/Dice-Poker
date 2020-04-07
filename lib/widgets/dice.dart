import 'package:dice_poker/data.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  final String data;

  Dice(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;
    if (data == '10' || data == 'K')
      color = Colors.red;
    else if (data == 'J')
      color = Colors.green[400];
    else if (data == 'Q') color = Colors.blue[700];
    return Center(
      child: Container(
        width: 44,
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(color: Colors.white, boxShadow: customShadow, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

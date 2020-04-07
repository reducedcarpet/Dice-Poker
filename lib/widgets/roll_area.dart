import 'package:dice_poker/data.dart';
import 'package:dice_poker/widgets/roll.dart';
import 'package:flutter/material.dart';

class RollArea extends StatefulWidget {
  RollArea({Key key}) : super(key: key);

  @override
  _RollAreaState createState() {
    return _RollAreaState();
  }
}

class _RollAreaState extends State<RollArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(color: Colors.white, boxShadow: customShadow, borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Roll(),
                Roll(),
                Roll(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:dice_poker/data.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Dice Poker',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              boxShadow: customShadow,
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: customShadow,
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      boxShadow: customShadow,
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Icon(Icons.notifications),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

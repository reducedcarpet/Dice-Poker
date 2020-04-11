import 'package:dice_poker/blocs/game_logic/game_logic_bloc.dart';
import 'package:dice_poker/widgets/header.dart';
import 'package:dice_poker/widgets/roll_area.dart';
import 'package:dice_poker/widgets/score_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dice Poker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: DicePokerPage(title: 'Flutter Dice Poker'),
    );
  }
}

class DicePokerPage extends StatefulWidget {
  DicePokerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DicePokerPageState createState() => _DicePokerPageState();
}

class _DicePokerPageState extends State<DicePokerPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double factor = 1;
    if (width > 800) {
      //factor = 0.8;
      width = 800;
    }

    return Center(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) => GameLogicBloc(),
          child: Center(
            child: Container(
              width: width * factor,
              child: Center(
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  //scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Header(),
                    RollArea(),
                    ScoreArea(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

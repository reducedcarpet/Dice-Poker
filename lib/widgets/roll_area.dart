import 'package:dice_poker/blocs/game_logic/game_logic_bloc.dart';
import 'package:dice_poker/data.dart';
import 'package:dice_poker/widgets/dice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RollArea extends StatefulWidget {
  RollArea({Key key}) : super(key: key);

  @override
  _RollAreaState createState() {
    return _RollAreaState();
  }
}

class _RollAreaState extends State<RollArea> {
  GameLogicBloc _gameLogicBloc;

  @override
  void initState() {
    super.initState();
    _gameLogicBloc = BlocProvider.of<GameLogicBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameLogicBloc glBloc = BlocProvider.of<GameLogicBloc>(context);

    return BlocBuilder<GameLogicBloc, GameLogicState>(
        bloc: glBloc,
        builder: (context, GameLogicState state) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: customShadow, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: <Widget>[
                      state.currentRollNumber == 0
                          ? MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                print('current roll: ' + state.currentRollNumber.toString());
                                //setState(() {
                                glBloc.add(RollTurn());

                                // });
                              },
                              child: Container(
                                child: Text('Roll'),
                              ),
                            )
                          : Row(
                              children: <Widget>[
                                Dice(state.currentRoll.roll[0]),
                                Dice(state.currentRoll.roll[1]),
                                Dice(state.currentRoll.roll[2]),
                                Dice(state.currentRoll.roll[3]),
                                Dice(state.currentRoll.roll[4]),
                                MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    //setState(() {
                                    print('current roll i: ' + state.currentRollNumber.toString());
                                    glBloc.add(RollTurn());
                                    print('current roll ii: ' + state.currentRollNumber.toString());
                                    // });
                                  },
                                  child: Container(
                                    child: Text('Roll'),
                                  ),
                                ),
                              ],
                            )
                      //Roll(),
                      //Roll(),
                      //Roll(),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

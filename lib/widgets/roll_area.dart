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
  List<bool> keepers = [false, false, false, false, false];

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
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          keepers[0] = !keepers[0];
                                        });
                                      },
                                      child: Dice(state.currentRoll.roll[0], keepers[0])),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        keepers[1] = !keepers[1];
                                      });
                                    },
                                    child: Dice(state.currentRoll.roll[1], keepers[1]),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        keepers[2] = !keepers[2];
                                      });
                                    },
                                    child: Dice(state.currentRoll.roll[2], keepers[2]),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        keepers[3] = !keepers[3];
                                      });
                                    },
                                    child: Dice(state.currentRoll.roll[3], keepers[3]),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        keepers[4] = !keepers[4];
                                      });
                                    },
                                    child: Dice(state.currentRoll.roll[4], keepers[4]),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      //setState(() {
                                      print('current roll i: ' + state.currentRollNumber.toString());
                                      glBloc.add(RollTurnWithKeepers(keepers));
                                      print('current roll ii: ' + state.currentRollNumber.toString());
                                      // });
                                    },
                                    child: Container(
                                      child: Text('Roll'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      state.scoring ? Text(state.pokerName) : Container(),
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

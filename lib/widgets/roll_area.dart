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
    glBloc.close();
  }

  GameLogicBloc glBloc;

  @override
  Widget build(BuildContext context) {
    glBloc = BlocProvider.of<GameLogicBloc>(context);

    return BlocBuilder<GameLogicBloc, GameLogicState>(
        bloc: glBloc,
        builder: (context, GameLogicState state) {
          return Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: customShadow, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: <Widget>[
                    state.currentRollNumber == 0
                        ? MaterialButton(
                            color: Colors.deepOrange,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              glBloc.add(RollTurn());
                            },
                            child: Text('Roll'),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _diceContainer(0, state.firstRoll, state.currentRollNumber < 3),
                              _diceContainer(1, state.firstRoll, state.currentRollNumber < 3),
                              _diceContainer(2, state.firstRoll, state.currentRollNumber < 3),
                              _diceContainer(3, state.firstRoll, state.currentRollNumber < 3),
                              _diceContainer(4, state.firstRoll, state.currentRollNumber < 3),
                            ],
                          ),
                    state.currentRollNumber != 0 && state.currentRollNumber < 3
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  color: Colors.deepOrange,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    glBloc.add(RollTurn.withKeepers(keepers));
                                  },
                                  child: Container(
                                    child: Text('Roll'),
                                  ),
                                ),
                                FlatButton(
                                  color: Colors.lightBlueAccent,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    glBloc.add(KeepRollTurn());
                                  },
                                  child: Container(
                                    child: Text('Keep'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    state.currentRollNumber == 3
                        ? MaterialButton(
                            color: Colors.deepOrange,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              keepers = [false, false, false, false, false];
                              glBloc.add(RollTurn());
                            },
                            child: Text('2nd Roll'),
                          )
                        : state.currentRollNumber > 3
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _diceContainer(0, state.secondRoll, true),
                                  _diceContainer(1, state.secondRoll, true),
                                  _diceContainer(2, state.secondRoll, true),
                                  _diceContainer(3, state.secondRoll, true),
                                  _diceContainer(4, state.secondRoll, true),
                                ],
                              )
                            : Container(), // */
                    state.currentRollNumber > 3 && state.currentRollNumber < 6
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                              FlatButton(
                                color: Colors.deepOrange,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  glBloc.add(RollTurn.withKeepers(keepers));
                                },
                                child: Container(
                                  child: Text('Roll'),
                                ),
                              ),
                              FlatButton(
                                color: Colors.lightBlueAccent,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  keepers = [false, false, false, false, false];
                                  glBloc.add(ScoreTurn());
                                },
                                child: Container(
                                  child: Text('Score'),
                                ),
                              ),
                            ]),
                          )
                        : Container(),
                    state.scoring
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(state.pokerName),
                          )
                        : Container(),
                    state.currentRollNumber == 6
                        ? Row(
                            children: <Widget>[
                              // next turn
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: FlatButton(
                                    color: Colors.deepOrange,
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      keepers = [false, false, false, false, false];
                                      glBloc.add(NextTurn());
                                    },
                                    child: Container(
                                      child: Text('Next Turn'),
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton(
                                color: Colors.lightBlueAccent,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  keepers = [false, false, false, false, false];
                                  glBloc.add(ScoreTurn());
                                },
                                child: Container(
                                  child: Text('Score'),
                                ),
                              ),
                            ],
                          )
                        : Container(),

                    // Text('Turn: ' + (state.currentTurn).toString()),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _diceContainer(int index, currentRoll, bool active) {
    return SizedBox(
      width: 60,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          if (active) {
            setState(() {
              keepers[index] = !keepers[index];
            });
          }
        },
        child: Dice(currentRoll.roll[index], active && keepers[index]),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dice_poker/blocs/game_logic/game_logic_bloc.dart';
import 'package:dice_poker/models/ScoreItem.dart';
import 'package:dice_poker/models/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreArea extends StatefulWidget {
  ScoreArea({Key key}) : super(key: key);

  @override
  _ScoreAreaState createState() {
    return _ScoreAreaState();
  }
}

class _ScoreAreaState extends State<ScoreArea> {
  @override
  void initState() {
    super.initState();
    titleColumn = [Center(child: Icon(Icons.arrow_downward)), Center(child: Icon(Icons.arrow_upward)), Center(child: Icon(Icons.star_half))];
    titleRow = ['9', '10', 'J', 'Q', 'K', 'A', '', 'Street', 'Full', 'Poker', 'Grand', 'Serve'];
  }

  @override
  void dispose() {
    super.dispose();
    glBloc.close();
  }

  List<Widget> titleColumn;
  List<String> titleRow;

  GameLogicBloc glBloc;

  List scoreboard;

  @override
  Widget build(BuildContext context) {
    glBloc = BlocProvider.of<GameLogicBloc>(context);

    return BlocBuilder<GameLogicBloc, GameLogicState>(
      bloc: glBloc,
      builder: (context, GameLogicState state) {
        scoreboard = _flattenMatrix(state);

        return Expanded(
          child: GridView.count(
            childAspectRatio: 3,
            mainAxisSpacing: 0,
            crossAxisCount: 4,
            children: scoreboard,
          ),
        );
      },
    );
  }

  List<Widget> _flattenMatrix(GameLogicState state) {
    List<Widget> flat = [];
    flat.add(Container());
    flat.addAll(titleColumn);

    for (int i = 0; i < titleRow.length; i++) {
      flat.add(Text(titleRow[i]));
      if (i == 6) {
        flat.add(_buildScoreCell(ScoreItem(false, 0, false, 0, i, false), state));
        flat.add(_buildScoreCell(ScoreItem(false, 0, false, 0, i, false), state));
        flat.add(_buildScoreCell(ScoreItem(false, 0, false, 0, i, false), state));
      } else {
        flat.add(_buildScoreCell(state.data[0][i], state));
        flat.add(_buildScoreCell(state.data[1][i], state));
        flat.add(_buildScoreCell(state.data[2][i], state));
      }
    }
    return flat;
  }

  Widget _buildScoreCell(ScoreItem item, GameLogicState state) {
    String dat = ' ';
    if (item.used && item.score == -1)
      dat = '-'; // scored out
    else if (item.used) dat = item.score.toString();
    if (item.possibility) dat = item.score.toString();

    return GestureDetector(
      onTap: () {
        if (item.possibility) {
          print('choosing: score: ' + item.score.toString() + ' - ' + item.col.toString() + ',' + item.index.toString());
          glBloc.add(PlaceScore(item.col, item.index, Score(true, item.score, '', item.index), item.firstScore));
          setState(() {
            scoreboard = _flattenMatrix(state);
          });
          print('Build 1: ' + state.scoreMatrixFirst.toString());
          print('Build 2: ' + state.scoreMatrixSecond.toString());
        }
      },
      child: Container(
        height: 20,
        color: item.possibility ? Colors.blue[300] : Colors.white,
        child: Center(
            child: AutoSizeText(
          dat,
          style: TextStyle(fontWeight: FontWeight.bold, color: item.possibility ? Colors.white : Colors.black),
        )),
      ),
    );
  }
}

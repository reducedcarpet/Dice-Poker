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

  List<List<ScoreItem>> data = [];
  List<Widget> titleColumn;
  List<String> titleRow;

  GameLogicBloc glBloc;

  @override
  Widget build(BuildContext context) {
    glBloc = BlocProvider.of<GameLogicBloc>(context);

    return BlocBuilder<GameLogicBloc, GameLogicState>(
      bloc: glBloc,
      builder: (context, GameLogicState state) {
        data = _initData(state);

        return Expanded(
          child: GridView.count(
            childAspectRatio: 3,
            mainAxisSpacing: 0,
            crossAxisCount: 4,
            children: _flattenMatrix(state),
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
      flat.add(_buildScoreCell(data[0][i], state));
      flat.add(_buildScoreCell(data[1][i], state));
      flat.add(_buildScoreCell(data[2][i], state));
    }
    return flat;
  }

  // TODO this contains too much game logic and should be in the bloc.
  List<List<ScoreItem>> _initData(GameLogicState state) {
    if (state.scoreMatrixFirst != null || state.scoreMatrixSecond != null)
      state.scoreMatrixFirst.forEach((sc) => print("1st: Score: " + sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));
    if (state.scoreMatrixSecond != null || state.scoreMatrixSecond != null)
      state.scoreMatrixFirst.forEach((sc) => print("2nd: Score: " + sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));

    List<List<ScoreItem>> result = [];
    List<ScoreItem> down = [];
    int index = 0;
    for (int i in state.scorecard.down) {
      bool poss = false;
      if ((state.scoreMatrixFirst != null && state.scoreMatrixFirst.isNotEmpty) || (state.scoreMatrixSecond != null && state.scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = state.scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = state.scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);
        if (sco1 != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index > 0 && state.scorecard.down[index - 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == 0 && i == 0) poss = true;

          if (poss) down.add(ScoreItem(i != 0, sco1.score, poss, 0, index, true));
        }

        if (sco2 != null) {
          if (index > 0 && state.scorecard.down[index - 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == 0 && i == 0) poss = true;
          if (poss) down.add(ScoreItem(i != 0, sco2.score, poss, 0, index, false));
        }
      }
      if (!poss) down.add(ScoreItem(i != 0, i, poss, 0, index, false));

      index++;
    }

    result.add(down);

    List<ScoreItem> up = [];
    index = 0;
    for (int i in state.scorecard.up) {
      bool poss = false;
      if ((state.scoreMatrixFirst != null && state.scoreMatrixFirst.isNotEmpty) || (state.scoreMatrixSecond != null && state.scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = state.scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = state.scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);

        if (sco1 != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index < state.scorecard.up.length - 1 && state.scorecard.up[index + 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == state.scorecard.down.length - 1 && i == 0) poss = true;

          if (poss) up.add(ScoreItem(i != 0, sco1.score, poss, 1, index, true));
        }

        if (sco2 != null) {
          if (index < state.scorecard.up.length - 1 && state.scorecard.up[index + 1] != 0) {
            if (i == 0) poss = true;
          } else if (index == state.scorecard.down.length - 1 && i == 0) poss = true;

          if (poss) up.add(ScoreItem(i != 0, sco2.score, poss, 1, index, false));
        }
      }

      if (!poss) up.add(ScoreItem(i != 0, i, poss, 1, index, false));
      index++;
    }

    result.add(up);

    List<ScoreItem> any = [];
    index = 0;
    for (int i in state.scorecard.any) {
      bool poss = false;
      if ((state.scoreMatrixFirst != null && state.scoreMatrixFirst.isNotEmpty) || (state.scoreMatrixSecond != null && state.scoreMatrixSecond.isNotEmpty)) {
        Score sco1 = state.scoreMatrixFirst.firstWhere((sc) => sc.index == index, orElse: () => null);
        Score sco2 = state.scoreMatrixSecond.firstWhere((sc) => sc.index == index, orElse: () => null);
        //state.scoreMatrix.forEach((sc) => print(sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));
        if (sco1 != null) {
          // Something has been found!
          if (i == 0) {
            poss = true;
            any.add(ScoreItem(i != 0, sco1.score, poss, 2, index, true));
          }
        }

        if (sco2 != null) {
          // Something has been found!
          if (i == 0) {
            poss = true;
            any.add(ScoreItem(i != 0, sco2.score, poss, 2, index, false));
          }
        }
      }

      if (!poss) any.add(ScoreItem(i != 0, i, poss, 2, index, false));
      index++;
    }

    result.add(any);

    return result;
  }

  Widget _buildScoreCell(ScoreItem item, GameLogicState state) {
    String dat = ' ';
    if (item.used && item.score == -1)
      dat = '-'; // scored out
    else if (item.used) dat = item.score.toString();

    return GestureDetector(
      onTap: () {
        if (item.possibility) {
          print('choosing: score: ' + item.score.toString() + ' - ' + item.col.toString() + ',' + item.index.toString());
          glBloc.add(PlaceScore(item.col, item.index, Score(true, item.score, '', item.index), item.firstScore));
          print('Build 1: ' + state.scoreMatrixFirst.toString());
          print('Build 2: ' + state.scoreMatrixSecond.toString());
          setState(() {
            data = _initData(state);
          });
        }
      },
      child: Container(
        height: 20,
        color: item.possibility ? Colors.blue[300] : Colors.white,
        child: Center(child: AutoSizeText(dat)),
      ),
    );
  }
}

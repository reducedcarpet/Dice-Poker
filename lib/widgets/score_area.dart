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
            children: _flattenMatrix(),
          ),
        );
      },
    );
  }

  List<Widget> _flattenMatrix() {
    List<Widget> flat = [];
    flat.add(Container());
    flat.addAll(titleColumn);

    for (int i = 0; i < titleRow.length; i++) {
      flat.add(Text(titleRow[i]));
      flat.add(_buildScoreCell(data[0][i]));
      flat.add(_buildScoreCell(data[1][i]));
      flat.add(_buildScoreCell(data[2][i]));
    }
    return flat;
  }

  List<List<ScoreItem>> _initData(GameLogicState state) {
    List<List<ScoreItem>> result = [];
    List<ScoreItem> down = [];
    int index = 0;
    for (int i in state.scorecard.down) {
      bool poss = false;
      if (state.scoreMatrix != null && state.scoreMatrix.isNotEmpty) {
        Score sco = state.scoreMatrix.firstWhere((sc) => sc.index == index, orElse: () => null);
        if (sco != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index > 0 && state.scorecard.down[index - 1] != 0) {
            poss = true;
          } else if (index == 0) poss = true;

          if (poss) down.add(ScoreItem(i != 0, sco.score, poss, 0, index));
        }
      }
      if (!poss) down.add(ScoreItem(i != 0, i, poss, 0, index));

      index++;
    }

    result.add(down);

    List<ScoreItem> up = [];
    index = 0;
    for (int i in state.scorecard.up) {
      bool poss = false;
      if (state.scoreMatrix != null && state.scoreMatrix.isNotEmpty) {
        Score sco = state.scoreMatrix.firstWhere((sc) => sc.index == index, orElse: () => null);
        if (sco != null) {
          // Something has been found!
          // but unless the previous entry is filled we can't use this scoring box
          if (index < state.scorecard.up.length - 1 && state.scorecard.up[index + 1] != 0) {
            poss = true;
          } else if (index == state.scorecard.down.length - 1) poss = true;

          if (poss) up.add(ScoreItem(i != 0, sco.score, poss, 1, index));
        }
      }

      if (!poss) up.add(ScoreItem(i != 0, i, poss, 1, index));
      index++;
    }

    result.add(up);

    List<ScoreItem> any = [];
    index = 0;
    for (int i in state.scorecard.any) {
      bool poss = false;
      if (state.scoreMatrix != null && state.scoreMatrix.isNotEmpty) {
        Score sco = state.scoreMatrix.firstWhere((sc) => sc.index == index, orElse: () => null);
        //state.scoreMatrix.forEach((sc) => print(sc.score.toString() + ' ' + sc.name + ' ' + sc.index.toString()));
        if (sco != null) {
          // Something has been found!
          poss = true;
        }
        if (poss) any.add(ScoreItem(i != 0, sco.score, poss, 2, index));
      }

      if (!poss) any.add(ScoreItem(i != 0, i, poss, 2, index));
      index++;
    }

    result.add(any);

    return result;
  }

  Widget _buildScoreCell(ScoreItem item) {
    String data = ' ';
    if (item.used && item.score == -1)
      data = '-'; // scored out
    else if (item.used) data = item.score.toString();

    //if (item.possibility) print('item.score: ' + item.score.toString());

    return GestureDetector(
      onTap: () {
        if (item.possibility) {
          print('choosing: sc' + item.score.toString() + ' - ' + item.col.toString() + ',' + item.index.toString());
          glBloc.add(PlaceScore(item.col, item.index, item.score));
        }
      },
      child: Container(
        height: 20,
        color: item.possibility ? Colors.blue[300] : Colors.white,
        child: Center(child: AutoSizeText(data)),
      ),
    );
  }

  List<Widget> _buildScoreMatrix(GameLogicState state) {
    List<Widget> result = [];
    if (state.scoreMatrix != null && state.scoreMatrix.isNotEmpty) {
      for (Score key in state.scoreMatrix) {
        //print(key.name + ' - ' + key.score.toString() + 'pts');
        result.add(Text(key.name + ' - ' + key.score.toString() + 'pts'));
      }
    }
    return result;
  }
}

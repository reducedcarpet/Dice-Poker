import 'package:dice_poker/blocs/game_logic/game_logic_bloc.dart';
import 'package:dice_poker/models/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

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
    titleColumn = [Icon(Icons.arrow_downward), Icon(Icons.arrow_upward), Icon(Icons.star_half)];
    titleRow = ['9', '10', 'J', 'Q', 'K', 'A', '', 'Street', 'Full', 'Poker', 'Grand', 'Serve'];
  }

  @override
  void dispose() {
    super.dispose();
    glBloc.close();
  }

  List<List<int>> data = [];
  List<Widget> titleColumn;
  List<String> titleRow;

  GameLogicBloc glBloc;

  @override
  Widget build(BuildContext context) {
    glBloc = BlocProvider.of<GameLogicBloc>(context);

    return BlocBuilder<GameLogicBloc, GameLogicState>(
      bloc: glBloc,
      builder: (context, GameLogicState state) {
        data.add(state.scorecard.down);
        data.add(state.scorecard.up);
        data.add(state.scorecard.any);

        return Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            state.scoreMatrix != null && state.scoreMatrix.isNotEmpty
                ? Column(
                    children: _buildScoreMatrix(state),
                  )
                : Container(),
            Expanded(
              child: StickyHeadersTable(
                columnsLength: titleColumn.length,
                rowsLength: titleRow.length,
                columnsTitleBuilder: (i) => titleColumn[i],
                rowsTitleBuilder: (i) => Text(titleRow[i]),
                contentCellBuilder: (i, j) => data[i][j] == 0 ? Container() : Text(data[i][j].toString()),
                legendCell: Text(''),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildScoreMatrix(GameLogicState state) {
    List<Widget> result = [];
    if (state.scoreMatrix != null && state.scoreMatrix.isNotEmpty) {
      for (Score key in state.scoreMatrix) {
        print(key.name + ' - ' + key.score.toString() + 'pts');
        result.add(Text(key.name + ' - ' + key.score.toString() + 'pts'));
      }
    }
    return result;
  }
}

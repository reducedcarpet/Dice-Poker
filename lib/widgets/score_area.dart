import 'package:dice_poker/blocs/game_logic/game_logic_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ScoreArea extends StatelessWidget {
  ScoreArea({Key key}) : super(key: key) {
    titleColumn = [Icon(Icons.arrow_downward), Icon(Icons.arrow_upward), Icon(Icons.star_half)];
    titleRow = ['9', '10', 'J', 'Q', 'K', 'A'];
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

        return Container(
          child: StickyHeadersTable(
            columnsLength: titleColumn.length,
            rowsLength: titleRow.length,
            columnsTitleBuilder: (i) => titleColumn[i],
            rowsTitleBuilder: (i) => Text(titleRow[i]),
            contentCellBuilder: (i, j) => data[i][j] == 0 ? Container() : Text(data[i][j].toString()),
            legendCell: Text(''),
          ),
        );
      },
    );
  }
}

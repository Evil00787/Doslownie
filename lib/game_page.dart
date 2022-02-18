import 'logic/grid_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/grid.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    var widget = BlocBuilder<GridCubit, GridState>(
      builder: (context, state) => Center(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var y = 0; y < state.dimensions.y; y++)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var x = 0; x < state.dimensions.x; x++)
                  buildCell(state.letters[y].tiles[x], state.letters[y].state),
              ]),
          ]),
        ),
      ),
    );
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: widget,
        onKey: (event) {
          var cubit = context.read<GridCubit>();
          if (event is RawKeyDownEvent) {
            var letter = event.character;
            if (letter != null && RegExp(r'[a-zA-Z]').hasMatch(letter)) {
              cubit.letter(letter.toLowerCase());
            } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              cubit.confirm();
            } else if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              cubit.clear();
            }
          }
        },
      ),
    );
  }

  Padding buildCell(Tile tile, TileRowState rowState) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: rowState != TileRowState.locked ? tile.validation?.color(primaryColor).withAlpha(160) ?? primaryColor : null,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: rowState == TileRowState.locked ? Border.all(width: 4, color: primaryColor) : null,
          ),
          child: Center(
            child: Text(
              tile.letter,
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension TileColor on TileValidation {
  Color color(Color primary) {
    if (this == TileValidation.incorrect) return primary;
    return this == TileValidation.correct ? Colors.green : Colors.yellow;
  }
}
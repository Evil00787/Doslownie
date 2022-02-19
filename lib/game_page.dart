import 'widgets/keyboard.dart';
import 'widgets/letter_cell.dart';
import 'package:flutter/services.dart';

import 'logic/grid_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatelessWidget {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: BlocBuilder<GridCubit, GridState>(
          builder: (context, state) => Center(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var y = 0; y < state.dimensions.y; y++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var x = 0; x < state.dimensions.x; x++)
                              LetterCell(
                                tile: state.letters[y].tiles[x],
                                state: state.letters[y].state,
                              ),
                          ],
                        )
                    ],
                  ),
                  KeyboardWidget(state)
                ],
              ),
            ),
          ),
        ),
        onKey: (event) => _onKeyEvent(event, context),
      ),
    );
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/grid/grid_cubit.dart';
import '../widgets/dialogs/game_dialogs.dart';
import '../widgets/grid/game_grid.dart';

class GamePage extends StatelessWidget {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: GameDialogs(child: GameGrid()),
        onKey: (event) => _onKeyEvent(event, context),
      ),
    );
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var cubit = context.read<GridCubit>();
    if (event is RawKeyDownEvent) {
      var letter = event.character;
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        cubit.confirm();
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        cubit.clear();
      } else if (letter != null) {
        cubit.letter(letter.toUpperCase());
      }
    }
  }
}

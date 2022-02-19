import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/grid_cubit.dart';
import 'widgets/keyboard.dart';
import 'widgets/letter_cell.dart';

class GamePage extends StatelessWidget {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: _blocWrapper((c, state) => _buildGrid(state)),
        onKey: (event) => _onKeyEvent(event, context),
      ),
    );
  }

  Widget _blocWrapper(BlocWidgetBuilder<GridState> builder) {
    return BlocListener<GridCubit, GridState>(
      listener: (context, state) {
        _showFlushbar(
          message: state.state.message,
          context: context,
          icon: state.state.icon,
        );
      },
      listenWhen: (oldState, newState) => oldState.state != newState.state,
      child: BlocConsumer<GridCubit, GridState>(
        listener: (context, state) {
          if (state.message != null) {
            _showFlushbar(
              message: state.message!,
              context: context,
              icon: Icons.warning_rounded,
            );
          }
        },
        builder: (context, state) => builder(context, state),
      ),
    );
  }

  Center _buildGrid(GridState state) {
    return Center(
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
    );
  }

  void _showFlushbar({
    required String message,
    required BuildContext context,
    IconData? icon,
  }) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 5),
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: icon != null
          ? Icon(
              icon,
              size: 28.0,
              color: Theme.of(context).colorScheme.secondary,
            )
          : null,
      leftBarIndicatorColor: Theme.of(context).colorScheme.secondary,
    ).show(context);
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var cubit = context.read<GridCubit>();
    if (event is RawKeyDownEvent) {
      var letter = event.character;
      if (letter != null &&
          RegExp(r'[a-zA-ZąćęłóśńżźĄĆĘŁÓŚŃŻŹ]').hasMatch(letter)) {
        cubit.letter(letter.toLowerCase());
      } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        cubit.confirm();
      } else if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
        cubit.clear();
      }
    }
  }
}

extension GameStateMessage on GameState {
  String get message => const {
        GameState.initial: 'New game',
        GameState.ongoing: 'Game started',
        GameState.won: 'You won!',
        GameState.lost: 'Game over',
      }[this]!;

  IconData get icon => const {
        GameState.initial: Icons.not_started_rounded,
        GameState.ongoing: Icons.play_arrow_rounded,
        GameState.won: Icons.emoji_events_rounded,
        GameState.lost: Icons.clear_rounded,
      }[this]!;
}

import 'widgets/keyboard_widget.dart';
import 'widgets/letter_cell.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/grid_cubit.dart';

class GamePage extends StatelessWidget {
  final _focusNode = FocusNode();
  Flushbar? _flushbar;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: _blocWrapper((c, state) => _buildGrid(state, c)),
        onKey: (event) => _onKeyEvent(event, context),
      ),
    );
  }

  Widget _blocWrapper(BlocWidgetBuilder<GridState> builder) {
    return BlocListener<GridCubit, GridState>(
      listener: (context, state) {
        if (state.state == null) return;
        Button? button;
        if (state.state == GameState.initial) {
          button = Button('Begin', () => context.read<GridCubit>().startGame());
        }
        if (state.state == GameState.won || state.state == GameState.lost) {
          button = Button(
            'Play again',
            () => context.read<GridCubit>().restartGame(),
          );
        }
        _showFlushbar(
          message: state.state!.message,
          context: context,
          icon: state.state!.icon,
          button: button,
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

  Center _buildGrid(GridState state, context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBar(title: Center(child: Text("Dosłownie")), backgroundColor: Theme.of(context).colorScheme.primaryContainer,),
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
            KeyboardWidget()
          ],
        ),
      ),
    );
  }

  void _showFlushbar({
    required String message,
    required BuildContext context,
    IconData? icon,
    Button? button,
  }) {
    var accentColor = Theme.of(context).colorScheme.secondary;
    _flushbar = Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: button == null ? Duration(seconds: 5) : null,
      margin: EdgeInsets.all(4),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      borderRadius: BorderRadius.circular(8),
      icon: icon != null
          ? Icon(
              icon,
              size: 28.0,
              color: accentColor,
            )
          : null,
      mainButton: button != null
          ? TextButton(
              onPressed: () {
                _flushbar?.dismiss();
                button.action();
              },
              child: Text(button.text,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  )),
            )
          : null,
      leftBarIndicatorColor: accentColor,
    )..show(context);
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var cubit = context.read<GridCubit>();
    if (event is RawKeyDownEvent) {
      var letter = event.character;
      if (letter != null &&
          RegExp(r'[a-zA-ZąćęłóśńżźĄĆĘŁÓŚŃŻŹ]').hasMatch(letter)) {
        cubit.letter(letter.toUpperCase());
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

class Button {
  final String text;
  final void Function() action;

  Button(this.text, this.action);
}

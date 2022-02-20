import 'dart:math';

import 'package:doslownie/widgets/animated_tile.dart';
import 'package:doslownie/widgets/end_game_dialog.dart';

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
  EndGameDialog? endGameDialog;

  Duration tileDelay(int pos) => Duration(milliseconds: pos * 100);
  Duration tileAnimation = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: _blocListeners(_buildGrid(context)),
        onKey: (event) => _onKeyEvent(event, context),
      ),
    );
  }

  Widget _blocListeners(Widget child) {
    return BlocListener<GridCubit, GridState>(
      listener: (context, state) {
        if (state.state == null) return;
        if (state.state == GameState.initial) {
          _showFlushbar(
            message: state.state!.message,
            context: context,
            icon: state.state!.icon,
            button: Button(
              'Begin',
              () => context.read<GridCubit>().startGame(),
            ),
          );
        }
        if (state.state == GameState.won || state.state == GameState.lost) {
          var cubit = context.read<GridCubit>();
          _setupEndGameDialog(
            state.state!,
            () => cubit.restartGame(),
            cubit.word,
          );
          _showEndGameDialog(context);
        }
      },
      listenWhen: (oldState, newState) => oldState.state != newState.state,
      child: BlocListener<GridCubit, GridState>(
        listenWhen: (oldState, newState) => newState.message != null,
        listener: (context, state) => _showFlushbar(
          message: state.message!,
          context: context,
          icon: Icons.warning_rounded,
        ),
        child: child,
      ),
    );
  }

  Center _buildGrid(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<GridCubit, GridState>(
              buildWhen: (oldState, newState) =>
                  oldState.state != newState.state,
              builder: (context, state) => AppBar(
                title: Center(child: Text("Dosłownie")),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                actions: [
                  state.state == GameState.won || state.state == GameState.lost
                      ? IconButton(
                          onPressed: () => _showEndGameDialog(context),
                          icon: Icon(Icons.restart_alt),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            BlocBuilder<GridCubit, GridState>(
              builder: (context, state) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var y = 0; y < state.dimensions.y; y++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var x = 0; x < state.dimensions.x; x++)
                          AnimatedTile(
                            tile: state.tiles[y][x],
                            delay: tileDelay(x),
                            animationTime: tileAnimation,
                          ),
                      ],
                    )
                ],
              ),
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
      icon: icon != null ? Icon(icon, size: 28.0, color: accentColor) : null,
      mainButton: button != null
          ? TextButton(
              onPressed: () {
                _flushbar?.dismiss();
                button.action();
              },
              child: Text(
                button.text,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          : null,
      leftBarIndicatorColor: accentColor,
    )..show(context);
  }

  Future<void> _showEndGameDialog(BuildContext context) async {
    var wordLength = context.read<GridCubit>().state.dimensions.x;
    return Future.delayed(tileDelay(wordLength) + tileAnimation).then(
      (value) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => endGameDialog!,
      ),
    );
  }

  void _setupEndGameDialog(
    GameState state,
    void Function() newGameFun,
    String hiddenWord,
  ) {
    endGameDialog = EndGameDialog(
      gameState: state,
      startNewGame: () => newGameFun(),
      hiddenWord: hiddenWord,
    );
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var cubit = context.read<GridCubit>();
    if (event is RawKeyDownEvent) {
      var letter = event.character;
      var pattern = r'[a-zA-ZąćęłóśńżźĄĆĘŁÓŚŃŻŹ]';
      if (letter != null && RegExp(pattern).hasMatch(letter)) {
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

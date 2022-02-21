import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/game_config_cubit.dart';
import 'logic/grid/grid_cubit.dart';
import 'models/game_state.dart';
import 'widgets/animated_tile.dart';
import 'widgets/end_game_dialog.dart';
import 'widgets/keyboard_widget.dart';

class GamePage extends StatelessWidget {
  final _focusNode = FocusNode();

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
      listenWhen: (oldState, newState) => oldState.state != newState.state,
      listener: (context, state) {
        if (state.state == GameState.won || state.state == GameState.lost) {
          _showEndGameDialog(context, state.state!);
        }
      },
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

  Widget _buildGrid(BuildContext context) {
    var dimensions = context.read<GameConfigCubit>().state.dimensions;
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBar(
              title: Center(child: Text("Dosłownie")),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              actions: [
                state.state == GameState.won || state.state == GameState.lost
                    ? IconButton(
                        onPressed: () {
                          _showEndGameDialog(context, state.state!, noDelay: true);
                        },
                        icon: Icon(Icons.restart_alt))
                    : SizedBox.shrink()
              ],
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var y = 0; y < dimensions.y; y++)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var x = 0; x < dimensions.x; x++)
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: AnimatedTile(
                                    tile: state.tiles[y][x],
                                    delay: tileDelay(x + y),
                                    animationTime: tileAnimation,
                                  ),
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            KeyboardWidget()
          ],
        ),
      ),
    );
  }

  void _showEndGameDialog(BuildContext context, GameState state, {bool noDelay = false}) {
    var cubit = context.read<GridCubit>();
    var wordLength = context.read<GameConfigCubit>().state.dimensions.x;
    Future.delayed(noDelay ? Duration() : tileDelay(wordLength) + tileAnimation).then(
          (value) => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, _, __) => EndGameDialog(
          gameState: state,
          startNewGame: () => cubit.restartGame(),
          hiddenWord: cubit.word,
        )
      ),
    );
  }

  void _showFlushbar({
    required String message,
    required BuildContext context,
    IconData? icon,
  }) {
    var accentColor = Theme.of(context).colorScheme.secondary;
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.all(4),
      duration: Duration(seconds: 5),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      borderRadius: BorderRadius.circular(8),
      icon: icon != null ? Icon(icon, size: 28.0, color: accentColor) : null,
      leftBarIndicatorColor: accentColor,
    ).show(context);
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var cubit = context.read<GridCubit>();
    if (event is RawKeyDownEvent) {
      var letter = event.character;
      if (letter != null) {
        cubit.letter(letter.toUpperCase());
      } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        cubit.confirm();
      } else if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
        cubit.clear();
      }
    }
  }
}

class Button {
  final String text;
  final void Function() action;

  Button(this.text, this.action);
}

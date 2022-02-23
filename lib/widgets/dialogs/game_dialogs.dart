import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/game_config_cubit.dart';
import '../../logic/grid/grid_cubit.dart';
import '../../models/game_state.dart';
import 'end_game_dialog.dart';
import '../grid/game_grid.dart';

class GameDialogs extends StatelessWidget {
  final Widget child;

  GameDialogs({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GridCubit, GridState>(
      listenWhen: (oldState, newState) => oldState.state != newState.state,
      listener: (context, state) {
        if (state.state == GameState.won || state.state == GameState.lost) {
          showEndGameDialog(context, state.state!);
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

  static void showEndGameDialog(
    BuildContext context,
    GameState state, {
    bool noDelay = false,
  }) {
    var cubit = context.read<GridCubit>();
    var wordLength = context.read<GameConfigCubit>().state.dimensions.x;
    var delay = GameGrid.tileDelay(wordLength) + GameGrid.tileAnimation;
    Future.delayed(noDelay ? Duration() : delay).then(
      (value) => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, _, __) => EndGameDialog(
          gameState: state,
          startNewGame: () => cubit.restartGame(),
          hiddenWord: cubit.word,
        ),
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
}

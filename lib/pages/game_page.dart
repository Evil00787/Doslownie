import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/grid/grid_cubit.dart';
import '../logic/qube_cubit.dart';
import '../models/status.dart';
import '../services/app_locales.dart';
import '../widgets/animation/grid_qube_view.dart';
import '../widgets/dialogs/game_dialogs.dart';
import '../widgets/keyboard/keyboard_widget.dart';

class GamePage extends StatelessWidget {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(context, state),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
        body: RawKeyboardListener(
          focusNode: focusNode,
          child: GameDialogs(
            child: Center(
              child: BlocBuilder<QubeCubit, GridQubeState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQube(state),
                      _buildKeyboard(state),
                    ],
                  );
                },
              ),
            ),
          ),
          onKey: (event) => _onKeyEvent(event, context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, GridState state) {
    var newGame = IconButton(
      onPressed: () => context.read<GridCubit>().restartGame(),
      icon: Icon(Icons.restart_alt),
    );
    return AppBar(
      title: Text(AppLocales.I('title')),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [(state.status.finished) ? newGame : SizedBox.shrink()],
    );
  }

  Expanded _buildQube(GridQubeState state) {
    return Expanded(
      child: AnimatedPadding(
        duration: Duration(milliseconds: 1000),
        padding: EdgeInsets.all(state.status == QubeStatus.game ? 0 : 100),
        child: QubeView(),
      ),
    );
  }

  AnimatedSize _buildKeyboard(GridQubeState state) {
    var height = state.status == QubeStatus.game ? double.infinity : 0.0;
    return AnimatedSize(
      duration: Duration(milliseconds: 1000),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: KeyboardWidget(),
      ),
    );
  }

  void _onKeyEvent(RawKeyEvent event, BuildContext context) {
    var qube = context.read<QubeCubit>();
    if (qube.state.status == QubeStatus.qube) {
      if (event is! RawKeyDownEvent) return;
      var key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowRight) qube.changeHighlight(true);
      if (key == LogicalKeyboardKey.arrowLeft) qube.changeHighlight(false);
    } else {
      var grid = context.read<GridCubit>();
      if (event is! RawKeyDownEvent) return;
      var letter = event.character;
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        grid.confirm();
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        grid.clear();
      } else if (letter != null) {
        grid.letter(letter.toUpperCase());
      }
    }
  }
}

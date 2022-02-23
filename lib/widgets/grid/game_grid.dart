import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/game_config_cubit.dart';
import '../../logic/grid/grid_cubit.dart';
import '../../models/game_state.dart';
import '../../services/app_locales.dart';
import 'animated_tile.dart';
import '../dialogs/game_dialogs.dart';
import '../keyboard/keyboard_widget.dart';

class GameGrid extends StatelessWidget {
  GameGrid();

  static Duration tileDelay(int pos) => Duration(milliseconds: pos * 100);
  static Duration tileAnimation = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAppBar(context, state),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: BlocBuilder<GameConfigCubit, GameConfigState>(
                    buildWhen: (oldState, newState) => oldState.dimensions != newState.dimensions,
                    builder: (_, config) => _buildGrid(config.dimensions, state),
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

  Column _buildGrid(Point<int> dimensions, GridState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var y = 0; y < dimensions.y; y++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            ),
          )
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context, GridState state) {
    return AppBar(
      title: Text(AppLocales.I('title')),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        state.state == GameState.won || state.state == GameState.lost
            ? IconButton(
                onPressed: () => GameDialogs.showEndGameDialog(
                  context,
                  state.state!,
                  noDelay: true,
                ),
                icon: Icon(Icons.restart_alt),
              )
            : SizedBox.shrink()
      ],
    );
  }
}

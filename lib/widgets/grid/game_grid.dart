import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/game_config_cubit.dart';
import '../../logic/grid/grid_cubit.dart';
import '../custom_app_bar.dart';
import 'animated_tile.dart';
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
            CustomAppBar(state: state),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: _buildGrid(
                    context.watch<GameConfigCubit>().state.dimensions,
                    state,
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

  Widget _buildGrid(Point<int> dimensions, GridState state) {
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var y = 0; y < dimensions.y; y++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var x = 0; x < dimensions.x; x++)
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: AnimatedTile(
                            tile: state.tiles[y][x],
                            delay: tileDelay(x + y),
                            animationTime: tileAnimation,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

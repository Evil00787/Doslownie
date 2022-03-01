import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/game_config_cubit.dart';
import '../../models/grid.dart';
import 'animated_tile.dart';

class GameGrid extends StatelessWidget {
  final TileGrid grid;
  final double opacity;

  GameGrid({required this.grid, this.opacity = 1});

  static Duration tileDelay(int pos) => Duration(milliseconds: pos * 100);
  static Duration tileAnimation = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return ProxyProvider0<TileOpacity>(
      update: (_, __) => TileOpacity(opacity),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: _buildGrid(
            context.watch<GameConfigCubit>().state.dimensions,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(Point<int> dimensions) {
    return IntrinsicWidth(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var y = 0; y < dimensions.y; y++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildRow(dimensions, y),
              ),
            )
        ],
      ),
    );
  }

  Row _buildRow(Point<int> dimensions, int y) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var x = 0; x < dimensions.x; x++)
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedTile(
                tile: grid[y][x],
                delay: tileDelay(x + y),
                animationTime: tileAnimation,
              ),
            ),
          ),
      ],
    );
  }
}

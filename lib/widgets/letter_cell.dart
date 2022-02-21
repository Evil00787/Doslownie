import 'package:flutter/material.dart';

import '../models/grid.dart';
import '../styles/theme.dart';

class LetterCell extends StatelessWidget {
  final Tile tile;
  final Duration animationTime;
  Color? _currentColor;

  LetterCell({
    required this.tile,
    this.animationTime = Duration.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newColor = tile.state.color(context);
    _currentColor ??= newColor;

    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: _currentColor!,
            end: newColor,
          ),
          curve: Curves.easeInOut,
          onEnd: () => _currentColor = newColor,
          duration: animationTime,
          builder: (context, value, child) => _buildCell(context, value!),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: [TileState.locked, TileState.active].contains(tile.state)
            ? Border.all(width: 4, color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      child: Center(
        child: Text(
          tile.letter,
          style: TextStyle(
            fontSize: 25,
            color: tile.state.onColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

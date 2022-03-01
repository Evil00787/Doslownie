import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/grid.dart';
import '../../models/status.dart';
import '../../utils/theme.dart';
import '../../utils/utils.dart';
import '../animation/animated_value.dart';

class LetterCell extends StatelessWidget {
  final Tile tile;
  final Duration animationTime;

  LetterCell({
    required this.tile,
    this.animationTime = Duration.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newColor = tile.status.color(context);
    var opacity = context.watch<TileOpacity>().opacity;

    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        child: AnimatedValue<Color>(
          value: newColor,
          duration: animationTime,
          builder: (value) => _buildCell(context, value, opacity),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, Color color, double opacity) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.multiplyOpacity(opacity),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: [TileStatus.locked, TileStatus.active].contains(tile.status)
            ? Border.all(
                width: 4,
                color: Theme.of(context).colorScheme.primary.multiplyOpacity(opacity),
              )
            : null,
      ),
      child: Center(
        child: Text(
          tile.letter,
          style: TextStyle(
            fontSize: 25,
            color: tile.status.onColor(context).multiplyOpacity(opacity),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

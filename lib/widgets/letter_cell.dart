import 'package:doslownie/models/grid.dart';
import 'package:flutter/material.dart';

class LetterCell extends StatelessWidget {
  final Tile tile;
  final TileRowState state;

  const LetterCell(this.tile, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: state != TileRowState.locked ? tile.validation?.color(primaryColor).withAlpha(160) ?? primaryColor : null,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: state == TileRowState.locked ? Border.all(width: 4, color: primaryColor) : null,
          ),
          child: Center(
            child: Text(
              tile.letter,
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension TileColor on TileValidation {
  Color color(Color primary) {
    if (this == TileValidation.incorrect) return primary;
    return this == TileValidation.correct ? Colors.green : Colors.yellow;
  }
}
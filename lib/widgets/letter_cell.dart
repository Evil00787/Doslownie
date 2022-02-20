import 'package:doslownie/models/grid.dart';
import 'package:flutter/material.dart';
import 'package:doslownie/styles/theme.dart';

class LetterCell extends StatelessWidget {
  final Tile tile;

  const LetterCell({required this.tile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: _decoration(context),
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
        ),
      ),
    );
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: tile.state.color(context),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: tile.state == TileState.locked
            ? Border.all(width: 4, color: Theme.of(context).colorScheme.primary)
            : null,
      );
}

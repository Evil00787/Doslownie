import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doslownie/styles/theme.dart';
import '../logic/grid_cubit.dart';
import '../models/grid.dart';

class KeyboardButton extends StatelessWidget {
  final Tile tile;

  const KeyboardButton(this.tile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ExpandTapWidget(
          tapPadding: const EdgeInsets.all(4.0),
          onTap: () {
            var cubit = context.read<GridCubit>();
            if (tile.letter == "✔") {
              cubit.confirm();
              HapticFeedback.lightImpact();
            } else if (tile.letter == "⌫") {
              cubit.clear();
              HapticFeedback.mediumImpact();
            } else {
              cubit.letter(tile.letter.toLowerCase());
              HapticFeedback.heavyImpact();
            }
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.padded,
              primary: tile.letter == "✔" ? Theme.of(context).colorScheme.primary :
              tile.letter == "⌫" ? Theme.of(context).colorScheme.secondary : tile.validation?.color(context, isKeyboard: true),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
            onPressed: () {
              var cubit = context.read<GridCubit>();
              if (tile.letter == "✔") {
                cubit.confirm();
                HapticFeedback.lightImpact();
              } else if (tile.letter == "⌫") {
                cubit.clear();
                HapticFeedback.mediumImpact();
              } else {
                cubit.letter(tile.letter.toLowerCase());
                HapticFeedback.heavyImpact();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                tile.letter,
                style: TextStyle(
                  fontSize: 25,
                  color: tile.letter == "✔" ? Theme.of(context).colorScheme.onPrimary :
                  tile.letter == "⌫" ? Theme.of(context).colorScheme.onSecondary : tile.validation?.onColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

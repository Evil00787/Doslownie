import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doslownie/styles/theme.dart';
import '../logic/grid_cubit.dart';
import '../models/grid.dart';

class KeyboardButton extends StatelessWidget {
  final Tile tile;

  bool get isConfirm => tile.letter == "✔";
  bool get isBackspace => tile.letter == "⌫";

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
            if (isConfirm) {
              cubit.confirm();
              HapticFeedback.lightImpact();
            } else if (isBackspace) {
              cubit.clear();
              HapticFeedback.mediumImpact();
            } else {
              cubit.letter(tile.letter.toLowerCase());
              HapticFeedback.heavyImpact();
            }
          },
          child: _buildButton(context),
        ),
      ),
    );
  }

  ElevatedButton _buildButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
        primary: isConfirm
            ? Theme.of(context).colorScheme.primary
            : isBackspace
                ? Theme.of(context).colorScheme.secondary
                : tile.state.color(context, isKeyboard: true),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onPressed: () {
        var cubit = context.read<GridCubit>();
        if (isConfirm) {
          cubit.confirm();
          HapticFeedback.lightImpact();
        } else if (isBackspace) {
          cubit.clear();
          HapticFeedback.mediumImpact();
        } else {
          cubit.letter(tile.letter.toLowerCase());
          HapticFeedback.heavyImpact();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: _buildSign(context),
      ),
    );
  }

  Widget _buildSign(BuildContext context) {
    if (["✔", "⌫"].contains(tile.letter)) {
      var colors = Theme.of(context).colorScheme;
      return Icon(
        isConfirm ? Icons.check_rounded : Icons.backspace_rounded,
        size: 30,
        color: isConfirm ? colors.onPrimary : colors.onSecondary,
      );
    }
    return Text(
      tile.letter,
      style: TextStyle(
        fontSize: 25,
        color: tile.state.onColor(context),
      ),
      textAlign: TextAlign.center,
    );
  }
}

import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/grid/grid_cubit.dart';
import '../../models/grid.dart';
import '../../utils/theme.dart';

class KeyboardButton extends StatelessWidget {
  final Tile tile;
  final Duration animationTime;
  Color? _currentColor;

  bool get isConfirm => tile.letter == "✔";
  bool get isBackspace => tile.letter == "⌫";

  KeyboardButton({
    required this.tile,
    this.animationTime = Duration.zero,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ExpandTapWidget(
          tapPadding: const EdgeInsets.all(4.0),
          onTap: () => _onTap(context),
          child: _buildButton(context),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
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
  }

  Color _buttonColor(BuildContext context) => isConfirm
      ? Theme.of(context).colorScheme.primary
      : isBackspace
          ? Theme.of(context).colorScheme.secondary
          : tile.state.color(context);

  Widget _buildButton(BuildContext context) {
    var newColor = _buttonColor(context);
    _currentColor ??= newColor;

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: _currentColor!,
        end: newColor,
      ),
      curve: Curves.easeInOut,
      onEnd: () => _currentColor = newColor,
      duration: animationTime,
      builder: (context, value, child) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: value,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onPressed: () => _onPressed(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: _buildSign(context),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
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

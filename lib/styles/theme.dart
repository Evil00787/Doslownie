import 'package:doslownie/models/grid.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  dynamic context;

  static final CustomTheme _customTheme = CustomTheme._internal();

  CustomTheme._internal();

  factory CustomTheme(context) {
    _customTheme.context = context;
    return _customTheme;
  }

  ThemeData getLightTheme(ColorScheme? lightDynamic) {
    ColorScheme colorScheme = const ColorScheme.light();
    if (lightDynamic != null) {
      colorScheme = lightDynamic;
    } else {
      colorScheme = colorScheme.copyWith(
        primary: Colors.blueGrey,
        onPrimary: Colors.white54,
        secondary: Colors.indigoAccent,
        onSecondary: Colors.black54,
        surfaceVariant: Colors.grey,
        surface: Colors.white,
        onSurfaceVariant: Colors.black54,
      );
    }
    return ThemeData(
        fontFamily: "RobotoMono", useMaterial3: true, colorScheme: colorScheme);
  }

  ThemeData getDarkTheme(ColorScheme? darkDynamic) {
    ColorScheme darkColorScheme = const ColorScheme.dark();
    if (darkDynamic != null) {
      darkColorScheme = darkDynamic;
    } else {
      darkColorScheme = darkColorScheme.copyWith(
        primary: Colors.indigoAccent,
        onPrimary: Colors.white60,
        secondary: Colors.blueGrey,
        onSecondary: Colors.white54,
        surfaceVariant: Colors.white24,
        surface: Colors.black26,
        onSurfaceVariant: Colors.white60,
        primaryContainer: Colors.indigoAccent.withAlpha(120),
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      fontFamily: "RobotoMono",
    );
  }
}

extension TileColor on TileState {
  Color? color(context, {bool isKeyboard = false}) => {
        TileState.incorrect: isKeyboard
            ? Theme.of(context).colorScheme.surfaceVariant.withAlpha(120)
            : Theme.of(context).colorScheme.surfaceVariant.withAlpha(120),
        TileState.moved: Colors.yellow
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(160),
        TileState.correct: Colors.green
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(160),
        TileState.unknown: Theme.of(context).colorScheme.surfaceVariant,
        TileState.locked: null,
        TileState.active: Theme.of(context).colorScheme.primary,
      }[this];

  Color onColor(context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (this == TileState.active) return colorScheme.onPrimary;
    return colorScheme.onSurfaceVariant;
  }
}

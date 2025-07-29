import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import '../models/grid.dart';

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
        fontFamily: "Coiny", useMaterial3: true, colorScheme: colorScheme);
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
        surfaceContainerHighest: Colors.grey[900],
        surface: Colors.black26,
        onSurfaceVariant: Colors.white60,
        primaryContainer: Colors.indigoAccent.withAlpha(120),
        onPrimaryContainer: Colors.indigo[200],
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      fontFamily: "Coiny",
    );
  }
}

extension TileColor on TileState {
  Color color(context) => {
        TileState.incorrect: Theme.of(context).colorScheme.surfaceVariant.withAlpha(120),
        TileState.moved: Colors.purple
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(160),
        TileState.correct: Colors.green
            .harmonizeWith(Theme.of(context).colorScheme.primary)
            .withAlpha(160),
        TileState.unknown: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(80),
        TileState.locked: Colors.transparent,
        TileState.active: Theme.of(context).colorScheme.primary,
      }[this]!;

  Color onColor(context) {
    var colorScheme = Theme.of(context).colorScheme;
    if (this == TileState.active) return colorScheme.onPrimary;
    return colorScheme.onSurfaceVariant;
  }
}

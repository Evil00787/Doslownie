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
        primary: Colors.blueGrey, onPrimary: Colors.white54, secondary: Colors.indigoAccent, onSecondary: Colors.black54, surfaceVariant: Colors.grey, surface: Colors.white, onSurfaceVariant: Colors.black54,
      );
    }
    return ThemeData(
      fontFamily: "RobotoMono", useMaterial3: true, colorScheme: colorScheme
    );
  }

  ThemeData getDarkTheme(ColorScheme? darkDynamic) {
    ColorScheme darkColorScheme = const ColorScheme.dark();
    if (darkDynamic != null) {
      darkColorScheme = darkDynamic;
    } else {
      darkColorScheme = darkColorScheme.copyWith(
        primary: Colors.blueGrey, onPrimary: Colors.white54, secondary: Colors.indigoAccent, onSecondary: Colors.white60, surfaceVariant: Colors.white24, surface: Colors.black26, onSurfaceVariant: Colors.white60
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme, useMaterial3: true, fontFamily: "RobotoMono"
    );
  }
}

extension TileColor on TileValidation {
  Color color(context, {bool isKeyboard = false}) {
    switch (this) {
      case TileValidation.incorrect:
        return isKeyboard ? Theme.of(context).colorScheme.surfaceVariant.withAlpha(80) : Theme.of(context).colorScheme.surfaceVariant.withAlpha(120);
      case TileValidation.moved:
        return Colors.yellow.harmonizeWith(Theme.of(context).colorScheme.primary).withAlpha(160);
      case TileValidation.correct:
        return Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary).withAlpha(160);
      case TileValidation.unknown:
        return Theme.of(context).colorScheme.surfaceVariant;
    }
  }

  Color onColor(context) {
    switch (this) {
      case TileValidation.incorrect:
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case TileValidation.moved:
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case TileValidation.correct:
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case TileValidation.unknown:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}

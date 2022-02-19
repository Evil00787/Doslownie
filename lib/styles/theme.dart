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

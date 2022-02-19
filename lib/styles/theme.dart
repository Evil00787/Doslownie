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
        primary: Colors.blueGrey, onPrimary: Colors.white30, secondary: Colors.indigoAccent, onSecondary: Colors.white30, surfaceVariant: Colors.grey, surface: Colors.white, onSurfaceVariant: Colors.white,
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
        primary: Colors.blueGrey, onPrimary: Colors.white30, secondary: Colors.indigoAccent, onSecondary: Colors.white30, surfaceVariant: Colors.white24, surface: Colors.black26, onSurfaceVariant: Colors.black26
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme, useMaterial3: true, fontFamily: "RobotoMono"
    );
  }

  Color getDynamicGreen() {
    return Colors.green.harmonizeWith(Theme.of(context).colorScheme.primary);
  }

  Color getDynamicRed() {
    return Colors.red.harmonizeWith(Theme.of(context).colorScheme.primary);
  }
}

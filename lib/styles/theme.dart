import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme();

  ThemeData getLightTheme(ColorScheme? lightDynamic) {
    ColorScheme colorScheme = const ColorScheme.light();
    if (lightDynamic != null) {
      colorScheme = colorScheme.copyWith(
        primary: lightDynamic.primary,
      );
      colorScheme = colorScheme.harmonized();
    } else {
      colorScheme = colorScheme.copyWith(
        primary: Colors.blueGrey,
      );
    }
    return ThemeData(
      fontFamily: "RobotoMono", useMaterial3: true, colorScheme: colorScheme
    );
  }

  ThemeData getDarkTheme(ColorScheme? darkDynamic) {
    ColorScheme darkColorScheme = const ColorScheme.dark();
    if (darkDynamic != null) {
      darkColorScheme = darkColorScheme.copyWith(
        primary: darkDynamic.primary,
      );

      darkColorScheme = darkColorScheme.harmonized();
    } else {
      darkColorScheme = darkColorScheme.copyWith(
        primary: Colors.blueGrey,
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme, useMaterial3: true, fontFamily: "RobotoMono"
    );
  }
}

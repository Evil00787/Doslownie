import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme();

  ThemeData getLightTheme(ColorScheme? lightDynamic) {
    ColorScheme colorScheme = const ColorScheme.light();
    if (lightDynamic != null) {
      colorScheme = lightDynamic;
    } else {
      colorScheme = colorScheme.copyWith(
        primary: Colors.blueGrey, surfaceVariant: Colors.grey, surface: Colors.white
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
        primary: Colors.blueGrey, surfaceVariant: Colors.black12, surface: Colors.black26
      );
    }
    return ThemeData(
      colorScheme: darkColorScheme, useMaterial3: true, fontFamily: "RobotoMono"
    );
  }
}

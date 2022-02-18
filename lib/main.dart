import 'dart:math';

import 'package:doslownie/logic/grid_cubit.dart';
import 'package:doslownie/styles/theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: CustomTheme().getLightTheme(lightDynamic),
        darkTheme: CustomTheme().getDarkTheme(darkDynamic),
        themeMode: ThemeMode.system,
        home: BlocProvider<GridCubit>(
          create: (_) => GridCubit(Point<int>(5, 6)),
          child: GamePage(),
        ),
      );
    });
  }
}

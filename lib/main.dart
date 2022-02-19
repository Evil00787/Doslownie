import 'dart:math';

import 'package:doslownie/logic/grid_cubit.dart';
import 'package:doslownie/logic/keyboard_cubit.dart';
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
        theme: CustomTheme(context).getLightTheme(lightDynamic),
        darkTheme: CustomTheme(context).getDarkTheme(darkDynamic),
        themeMode: ThemeMode.dark,
        home: MultiBlocProvider(providers: [
          BlocProvider<KeyboardCubit>(
            lazy: true,
            create: (_) => KeyboardCubit(),
          ),
          BlocProvider<GridCubit>(
            lazy: true,
            create: (context) => GridCubit(
              Point<int>(6, 6),
              BlocProvider.of<KeyboardCubit>(context),
            ),
          ),
        ], child: GamePage()),
      );
    });
  }
}

import 'dart:math';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'game_page.dart';
import 'logic/game_config_cubit.dart';
import 'logic/grid/grid_cubit.dart';
import 'logic/keyboard_cubit.dart';
import 'logic/word_repository.dart';
import 'styles/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<WordRepository>(WordRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (
      ColorScheme? lightDynamic,
      ColorScheme? darkDynamic,
    ) {
      var size = Point<int>(5, 6);
      return MaterialApp(
        title: 'Flutter Demo',
        theme: CustomTheme(context).getLightTheme(lightDynamic),
        darkTheme: CustomTheme(context).getDarkTheme(darkDynamic),
        themeMode: ThemeMode.dark,
        home: _withCubit(
          _withCubit(
            _withCubit(
              GamePage(),
              (c) => GridCubit(c.read<GameConfigCubit>(), c.read<KeyboardCubit>()),
            ),
            (_) => GameConfigCubit(),
          ),
          (_) => KeyboardCubit(),
        ),
      );
    });
  }

  Widget _withCubit<T extends Cubit>(Widget widget, Create<T> cubit) {
    return BlocProvider<T>(
      create: cubit,
      child: widget,
    );
  }
}

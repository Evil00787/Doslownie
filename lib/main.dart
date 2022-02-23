import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'game_page.dart';
import 'logic/game_config_cubit.dart';
import 'logic/grid/grid_cubit.dart';
import 'logic/keyboard_cubit.dart';
import 'services/app_locales.dart';
import 'services/word_repository.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<WordRepository>(WordRepository());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements CurrentLocaleObserver {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (
      ColorScheme? lightDynamic,
      ColorScheme? darkDynamic,
    ) {
      return MaterialApp(
        title: 'Dosłownie',
        theme: CustomTheme(context).getLightTheme(lightDynamic),
        darkTheme: CustomTheme(context).getDarkTheme(darkDynamic),
        themeMode: ThemeMode.dark,

        localizationsDelegates: const [
          AppLocales.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalesDelegate.supportedLocales,
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

  @override
  void onLocaleSet(Locale locale) => setState(() {});

  @override
  void initState() {
    AppLocales.instance.observeLocaleChanges(this);
    super.initState();
  }
}

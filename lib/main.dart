import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'logic/game_config_cubit.dart';
import 'logic/grid/grid_cubit.dart';
import 'logic/keyboard_cubit.dart';
import 'pages/game_page.dart';
import 'pages/menu_page.dart';
import 'services/app_locales.dart';
import 'services/word_repository.dart';
import 'utils/theme.dart';
import 'utils/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  GetIt.I.registerSingleton<WordRepository>(WordRepository());
  runApp(CubitUtils.withCubit(MyApp(), (_) => GameConfigCubit()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements CurrentLocaleObserver {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? light, ColorScheme? dark) => MaterialApp(
        title: 'Dosłownie',
        theme: CustomTheme(context).getLightTheme(light),
        darkTheme: CustomTheme(context).getDarkTheme(dark),
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          AppLocales.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalesDelegate.supportedLocales,
        initialRoute: 'menu',
        routes: _createRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _createRoutes() => {
        'menu': (c) => MenuPage(),
        'game': (c) => CubitUtils.withCubit(
              CubitUtils.withCubit(
                GamePage(),
                (c) => GridCubit(
                  c.read<GameConfigCubit>(),
                  c.read<KeyboardCubit>(),
                ),
              ),
              (c) => KeyboardCubit(c.read<GameConfigCubit>()),
            ),
      };

  @override
  void onLocaleSet(Locale locale) => setState(() {});

  @override
  void initState() {
    AppLocales.instance.observeLocaleChanges(this);
    super.initState();
  }
}

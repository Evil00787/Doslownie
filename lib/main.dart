import 'package:doslownie/utils/cubit_utils.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'logic/game_config_cubit.dart';
import 'menu_page.dart';
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return DynamicColorBuilder(builder: (
      ColorScheme? lightDynamic,
      ColorScheme? darkDynamic,
    ) {
      return CubitUtils.withCubit(
          MaterialApp(
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
              home: MenuPage()),
          (_) => GameConfigCubit());
    });
  }

  @override
  void onLocaleSet(Locale locale) => setState(() {});

  @override
  void initState() {
    AppLocales.instance.observeLocaleChanges(this);
    super.initState();
  }
}

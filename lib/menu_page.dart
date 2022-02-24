import 'dart:math';

import 'package:doslownie/services/app_locales.dart';
import 'package:doslownie/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'game_page.dart';
import 'package:provider/provider.dart';
import 'logic/game_config_cubit.dart';
import 'logic/grid/grid_cubit.dart';
import 'logic/keyboard_cubit.dart';
import 'utils/cubit_utils.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
          body: Column(
            children: [
              CustomAppBar(),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
                  child: SvgPicture.asset("assets/icons/icon.svg",
                      color: Theme.of(context).colorScheme.primary)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        color: Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocales.I('settings.length'), style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onBackground)),
                              ),
                              CupertinoSlidingSegmentedControl(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
                                  thumbColor: Theme.of(context).colorScheme.primaryContainer,
                                  groupValue: context.read<GameConfigCubit>().state.dimensions.x,
                                  children: <int, Widget>{
                                    4: _getSegmentedText(4, context),
                                    5: _getSegmentedText(5, context),
                                    6: _getSegmentedText(6, context)
                                  },
                                  onValueChanged: (i) {
                                    var gameConfigCubit = context.read<GameConfigCubit>();
                                    setState(() {
                                      gameConfigCubit.setWordLength(Point(i as int, gameConfigCubit.state.dimensions.y));
                                    });
                                  }
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocales.I('settings.chances'), style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onBackground)),
                              ),
                              CupertinoSlidingSegmentedControl(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
                                  thumbColor: Theme.of(context).colorScheme.primaryContainer,
                                  groupValue: context.read<GameConfigCubit>().state.dimensions.y,
                                  children: <int, Widget>{
                                    4: _getSegmentedText(4, context),
                                    5: _getSegmentedText(5, context),
                                    6: _getSegmentedText(6, context),
                                    7: _getSegmentedText(7, context)
                                  },
                                  onValueChanged: (i) {
                                    var gameConfigCubit = context.read<GameConfigCubit>();
                                    setState(() {
                                      gameConfigCubit.setWordLength(Point(gameConfigCubit.state.dimensions.x, i as int));
                                    });
                                  }
                              ),
                            ],
                          ),
                        ),
                      )


                    ]),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CubitUtils.withCubit(
                            CubitUtils.withCubit(
                              GamePage(),
                                  (c) => GridCubit(
                                c.read<GameConfigCubit>(),
                                c.read<KeyboardCubit>(),
                              ),
                            ),
                                (c) => KeyboardCubit(
                              c.read<GameConfigCubit>(),
                            ),
                          ),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      AppLocales.I('start').toUpperCase(),
                      style: TextStyle(fontSize: 36),
                    ),
                  )),
            ],
          ),
        );
  }

  Widget _getSegmentedText(int number, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(number.toString(), style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimaryContainer)),
    );
  }
}

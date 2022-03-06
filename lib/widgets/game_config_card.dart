import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/game_config_cubit.dart';
import '../services/app_locales.dart';

class GameConfigCard extends StatelessWidget {
  GameConfigCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: EdgeInsets.all(6 + 2.w),
        child: BlocBuilder<GameConfigCubit, GameConfigState>(
          builder: (_, state) => Column(
            children: [
              if (state.wordLengths != null)
                ..._buildSlider(
                  context: context,
                  values: state.wordLengths!,
                  currentValue: state.dimensions.x,
                  setValue: (val) => Point<int>(val, state.dimensions.y),
                  title: 'settings.length',
                ),
              ..._buildSlider(
                context: context,
                values: context.watch<GameConfigCubit>().difficultyLevels,
                currentValue: state.dimensions.y,
                setValue: (val) => Point<int>(state.dimensions.x, val),
                title: 'settings.chances',
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlider({
    required BuildContext context,
    required List<int> values,
    required Point<int> Function(int) setValue,
    required int currentValue,
    required String title,
  }) {
    var scheme = Theme.of(context).colorScheme;
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocales.I(title),
          style: TextStyle(
            fontSize: 14 + 4.sp,
            color: scheme.onBackground,
          ),
        ),
      ),
      CupertinoSlidingSegmentedControl(
        backgroundColor: scheme.primaryContainer.withAlpha(60),
        thumbColor: scheme.primaryContainer,
        groupValue: currentValue,
        children: <int, Widget>{
          for (var a in values) a: _getSegmentedText(a, context),
        },
        onValueChanged: (i) => context.read<GameConfigCubit>().setWordLength(
              setValue(i as int),
            ),
      )
    ];
  }

  Widget _getSegmentedText(int number, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.w),
      child: Text(
        number.toString(),
        style: TextStyle(
          fontSize: 16 + 4.sp,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

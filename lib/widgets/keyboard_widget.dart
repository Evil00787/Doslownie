import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/keyboard_cubit.dart';
import 'keyboard_button.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardCubit, KeyboardState>(
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            for (var tileRow in state.tileRows)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var tile in tileRow)
                    KeyboardButton(
                      tile: tile,
                      animationTime: Duration(seconds: 1),
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

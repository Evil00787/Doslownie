import 'package:doslownie/logic/keyboard_cubit.dart';
import 'package:doslownie/widgets/keyboard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardCubit, KeyboardState>(
      builder: (context, state) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            for (var tileRow in state.tileRows)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [for (var tile in tileRow) KeyboardButton(tile)]),
          ],
        ),
      ),
    );
  }
}

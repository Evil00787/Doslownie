import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/grid_cubit.dart';

class KeyboardButton extends StatelessWidget {
  final String letter;

  const KeyboardButton(this.letter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: letter == "✔" ? Theme.of(context).colorScheme.primary :
            letter == "⌫" ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
          onPressed: () {
            var cubit = context.read<GridCubit>();

            if (letter == "✔") {
              cubit.confirm();
            } else if (letter == "⌫") {
              cubit.clear();
            } else {
              cubit.letter(letter.toUpperCase());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 25,
                color: letter == "✔" ? Theme.of(context).colorScheme.onPrimary :
                letter == "⌫" ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

import 'logic/grid_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    var widget = BlocBuilder<GridCubit, GridState>(
      builder: (context, state) => Center(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var y = 0; y < state.dimensions.y; y++)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var x = 0; x < state.dimensions.x; x++)
                  buildCell(state.letters[y][x]),
              ]),
          ]),
        ),
      ),
    );
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: widget,
        onKey: (key) {
          if (key is RawKeyDownEvent && key.character != null) {
            context.read<GridCubit>().letter(key.character!);
          }
        },
      ),
    );
  }

  Padding buildCell(String letter) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 25,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

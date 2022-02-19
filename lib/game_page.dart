import 'package:doslownie/widgets/keyboard.dart';
import 'package:doslownie/widgets/letter_cell.dart';

import 'logic/grid_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    var widget = BlocBuilder<GridCubit, GridState>(
      builder: (context, state) =>
          Center(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [for (var y = 0; y < state.dimensions.y; y++)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      for (var x = 0; x < state.dimensions.x; x++)
                        LetterCell(state.letters[y].tiles[x], state.letters[y].state),
                    ])
                  ],
                ),
                KeyboardWidget(state)
              ]),
            ),
          ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: widget,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/grid.dart';

class KeyboardCubit extends Cubit<KeyboardState> {
  KeyboardCubit() : super(KeyboardState(["ĄĆĘŁÓŚŃŻŹ", "QWERTYUIOP", "ASDFGHJKL", "✔ZXCVBNM⌫"]));

  void colorKeyboardKeys(List<Tile> tiles) {
    for (var tile in tiles) {
      var rowIndex = state.keyboardLayout.indexWhere((element) => element.contains(tile.letter));
      var tileIndex = state.tileRows[rowIndex].tiles.indexWhere((element) => element.letter == tile.letter);
      if(state.tileRows[rowIndex].tiles[tileIndex].validation != TileValidation.correct) state.tileRows[rowIndex].tiles[tileIndex] = tile;
    }
    emit(state);
  }

  void resetColors() {
    emit(KeyboardState(state.keyboardLayout));
  }
}

class KeyboardState {
  final List<String> keyboardLayout;
  late final List<TileRow> tileRows = [
    for (var row in keyboardLayout)
      TileRow(
        tiles: [
          for (var letter in row.characters)
            Tile(letter: letter, validation: TileValidation.unknown)
        ],
        state: TileRowState.active
      )
  ];

  KeyboardState(this.keyboardLayout);

  @override
  List<Object?> get props => [keyboardLayout];
}
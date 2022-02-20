import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/grid.dart';

class KeyboardCubit extends Cubit<KeyboardState> {
  static const List<String> _letters = [
    "ĄĆĘŁÓŚŃŻŹ",
    "QWERTYUIOP",
    "ASDFGHJKL",
    "✔ZXCVBNM⌫",
  ];

  KeyboardCubit() : super(KeyboardState(_tileRows()));

  void colorKeyboardKeys(List<Tile> tiles) {
    var newTiles = _tileRows(state.tileRows);
    for (var tile in tiles) {
      var rowIndex = _letters.indexWhere(
        (element) => element.contains(tile.letter),
      );
      var tileIndex = state.tileRows[rowIndex].indexWhere(
        (element) => element.letter == tile.letter,
      );
      if (state.tileRows[rowIndex][tileIndex].state !=
          TileState.correct) {
        newTiles[rowIndex][tileIndex] = tile;
      }
    }
    emit(KeyboardState(newTiles));
  }

  void resetColors() => emit(KeyboardState(_tileRows()));

  static List<List<Tile>> _tileRows([List<List<Tile>>? from]) => [
        for (var i = 0; i < _letters.length; i++)
          from?[i].copyWith() ??
              _letters[i]
                  .split('')
                  .map((e) => Tile(letter: e, state: TileState.unknown))
                  .toList(),
      ];
}

class KeyboardState extends Equatable {
  final List<List<Tile>> tileRows;

  KeyboardState(this.tileRows);

  @override
  List<Object?> get props => [tileRows];
}

import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/grid.dart';
import 'game_config_cubit.dart';

class KeyboardCubit extends Cubit<KeyboardState> {
  final GameConfigCubit _configCubit;

  KeyboardCubit(this._configCubit)
      : super(KeyboardState(_tileRows(_configCubit.state.locale)));

  static List<String> _letters(Locale locale) {
    var letters = [
      "QWERTYUIOP",
      "ASDFGHJKL",
      "✔ZXCVBNM⌫",
    ];
    if (locale == Locale('pl', 'PL')) letters.insert(0, "ĄĆĘŁÓŚŃŻŹ");
    return letters;
  }

  void colorKeyboardKeys(List<Tile> tiles) {
    var locale = _configCubit.state.locale;
    var newTiles = _tileRows(locale, state.tileRows);
    for (var tile in tiles) {
      var row = _letters(locale).indexWhere(
        (element) => element.contains(tile.letter),
      );
      var index = state.tileRows[row].indexWhere(
        (element) => element.letter == tile.letter,
      );
      var tileState = newTiles[row][index].state;
      if (tile.state.rank > tileState.rank) {
        newTiles[row][index] = tile;
      }
    }
    emit(KeyboardState(newTiles));
  }

  void resetColors() => emit(KeyboardState(_tileRows(_configCubit.state.locale)));

  static List<List<Tile>> _tileRows(Locale locale, [List<List<Tile>>? from]) {
    var letters = _letters(locale);
    return [
      for (var i = 0; i < letters.length; i++)
        from?[i].copyWith() ??
            letters[i]
                .split('')
                .map((e) => Tile(letter: e, state: TileState.unknown))
                .toList(),
    ];
  }
}

class KeyboardState extends Equatable {
  final List<List<Tile>> tileRows;

  KeyboardState(this.tileRows);

  @override
  List<Object?> get props => [tileRows];
}

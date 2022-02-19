import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/grid.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);

  GridCubit(Point<int> dimensions)
      : super(GridState(
          letters: [
            for (var y = 0; y < dimensions.y; y++)
              TileRow(
                tiles: List.filled(dimensions.x, Tile(letter: '')),
                state: RowState.fromIndex(y, 0),
              )
          ],
          dimensions: dimensions,
        ));

  void letter(String letter) {
    var gameEnded = pointer.y == state.dimensions.y;
    if (gameEnded || pointer.x == state.dimensions.x) return;
    var data = _copyLetters();
    data[pointer.y].tiles[pointer.x] = Tile(letter: letter);
    emit(state.copyWith(letters: data));
    pointer = Point<int>(pointer.x + 1, pointer.y);
  }

  void confirm() {
    if (pointer.x < state.dimensions.x) return;
    var data = _copyLetters();
    data[pointer.y] = data[pointer.y].copyWith(validation: [
      TileValidation.correct,
      TileValidation.incorrect,
      TileValidation.moved,
      TileValidation.moved,
      TileValidation.correct,
    ], state: TileRowState.completed);
    pointer = Point<int>(0, pointer.y + 1);
    data[pointer.y] = data[pointer.y].copyWith(state: TileRowState.active);
    emit(state.copyWith(letters: data));
  }

  void clear() {
    if (pointer.x == 0) return;
    pointer = Point<int>(pointer.x - 1, pointer.y);
    var data = _copyLetters();
    data[pointer.y].tiles[pointer.x] = Tile(letter: '');
    emit(state.copyWith(letters: data));
  }

  List<TileRow> _copyLetters() {
    return [
      for (var y = 0; y < state.dimensions.y; y++)
        state.letters[y].copyWith()
    ];
  }
}

class GridState extends Equatable {
  final Point<int> dimensions;
  final List<TileRow> letters;

  GridState({required this.letters, required this.dimensions});

  GridState copyWith({List<TileRow>? letters}) {
    return GridState(letters: letters ?? this.letters, dimensions: dimensions);
  }

  @override
  List<Object?> get props => [letters];
}

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
    emit(state.copyWith(
      (l) => l[pointer.y].tiles[pointer.x] = Tile(letter: letter),
      pointer.y,
    ));
    pointer = Point<int>(pointer.x + 1, pointer.y);
  }

  void confirm() {
    if (pointer.x < state.dimensions.x) return;
    pointer = Point<int>(0, pointer.y + 1);
    emit(state.copyWith((_) {}, pointer.y, [
      TileValidation.correct,
      TileValidation.incorrect,
      TileValidation.moved,
      TileValidation.moved,
      TileValidation.correct,
    ]));
  }

  void clear() {
    if (pointer.x == 0) return;
    pointer = Point<int>(pointer.x - 1, pointer.y);
    emit(state.copyWith(
      (l) => l[pointer.y].tiles[pointer.x] = Tile(letter: ''),
      pointer.y,
    ));
  }
}

class GridState extends Equatable {
  final Point<int> dimensions;
  final List<TileRow> letters;

  GridState({required this.letters, required this.dimensions});

  GridState copyWith(
    Function(List<TileRow>) transform,
    int currentRow, [
    List<TileValidation>? validation,
  ]) {
    var copy = [
      for (var y = 0; y < dimensions.y; y++)
        letters[y].copyWith(
          state: RowState.fromIndex(y, currentRow),
          validation: y == currentRow - 1 ? validation : null,
        )
    ];
    transform(copy);
    return GridState(letters: copy, dimensions: dimensions);
  }

  @override
  List<Object?> get props => [letters];
}

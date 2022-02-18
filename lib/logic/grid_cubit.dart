import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);

  GridCubit(Point<int> dimensions)
      : super(GridState(
          letters: List.generate(
            dimensions.y,
            (i) => List.filled(dimensions.x, ''),
          ),
          dimensions: dimensions,
        ));

  void letter(String letter) {
    if (pointer.y == state.dimensions.y) return;
    if (pointer.x < state.dimensions.x) {
      var newState = state.copyWith((l) => l[pointer.y][pointer.x] = letter);
      pointer = Point<int>(pointer.x + 1, pointer.y);
      emit(newState);
    }
    if (pointer.x == state.dimensions.x) {
      pointer = Point<int>(0, pointer.y + 1);
    }
  }

  void enter() {}
}

class GridState extends Equatable {
  final Point<int> dimensions;
  final List<List<String>> letters;

  GridState({required this.letters, required this.dimensions});

  GridState copyWith(Function(List<List<String>>) transform) {
    var copy = List.generate(
      dimensions.y,
      (i) => List.of(letters[i]),
    );
    transform(copy);
    return GridState(letters: copy, dimensions: dimensions);
  }

  @override
  List<Object?> get props => letters;
}

import 'package:equatable/equatable.dart';

enum TileState { incorrect, moved, correct, unknown, active, locked }

extension TileGroups on TileState {
  bool get uncovered => [TileState.incorrect, TileState.moved, TileState.correct].contains(this);

  int get rank {
    if (this == TileState.incorrect) return 1;
    if (this == TileState.moved) return 2;
    if (this == TileState.correct) return 3;
    return 0;
  }
}

class Tile extends Equatable {
  final String letter;
  final TileState state;

  Tile({required this.letter, required this.state});

  Tile copyWith({String? letter, TileState? state}) => Tile(
    letter: letter ?? this.letter,
    state: state ?? this.state,
  );

  @override
  List<Object?> get props => [letter, state];
}

extension TileCopy on List<Tile> {
  List<Tile> copyWith({List<TileState>? states}) => [
    for (var x = 0; x < length; x++)
      this[x].copyWith(state: states?[x] ?? this[x].state)
  ];
}


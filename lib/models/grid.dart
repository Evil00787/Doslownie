import 'package:equatable/equatable.dart';

enum TileState { incorrect, moved, correct, unknown, active, locked }

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


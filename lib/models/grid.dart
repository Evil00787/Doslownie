import 'package:equatable/equatable.dart';

enum TileValidation { incorrect, moved, correct, unknown }

class Tile extends Equatable {
  final String letter;
  final TileValidation? validation;

  Tile({required this.letter, this.validation});

  @override
  List<Object?> get props => [letter, validation];
}

enum TileRowState { active, locked, completed }

extension RowState on TileRowState {
  static TileRowState fromIndex(int index, int pointer) {
    var diff = index - pointer;
    if (diff == 0) return TileRowState.active;
    return diff > 0 ? TileRowState.locked : TileRowState.completed;
  }
}

class TileRow extends Equatable {
  final List<Tile> tiles;
  final TileRowState state;

  TileRow({required this.tiles, this.state = TileRowState.locked});

  TileRow copyWith({TileRowState? state, List<TileValidation>? validation}) {
    return TileRow(
      tiles: [
        for (var x = 0; x < tiles.length; x++)
          Tile(letter: tiles[x].letter, validation: validation?[x] ?? tiles[x].validation)
      ],
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [tiles, state];
}

import 'package:equatable/equatable.dart';

import 'status.dart';

typedef TileRow = List<Tile>;
typedef TileGrid = List<TileRow>;

class TileOpacity extends Equatable {
  final double opacity;

  TileOpacity(this.opacity);

  @override
  List<Object?> get props => [opacity];
}

class Tile extends Equatable {
  final String letter;
  final TileStatus status;

  Tile({required this.letter, required this.status});

  Tile copyWith({String? letter, TileStatus? status}) => Tile(
    letter: letter ?? this.letter,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [letter, status];
}

extension TileCopy on TileRow {
  TileRow copyWith({List<TileStatus>? states}) => [
    for (var x = 0; x < length; x++)
      this[x].copyWith(status: states?[x] ?? this[x].status)
  ];
}


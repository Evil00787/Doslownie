part of 'grid_cubit.dart';

class GridState extends Equatable {
  final TileGrid tiles;
  final String? message;
  final GameStatus status;

  GridState({
    required this.tiles,
    this.message,
    required this.status,
  });

  GridState copyWith({
    TileGrid? tiles,
    String? message,
    GameStatus? status,
  }) {
    return GridState(
      tiles: tiles ?? this.tiles,
      message: message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [tiles, message, status];
}

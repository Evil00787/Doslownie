part of 'grid_cubit.dart';

class GridState extends Equatable {
  final List<List<Tile>> tiles;
  final String? message;
  final GameState? state;

  GridState({
    required this.tiles,
    this.message,
    this.state,
  });

  GridState copyWith({
    List<List<Tile>>? tiles,
    String? message,
    GameState? state,
  }) {
    return GridState(
      tiles: tiles ?? this.tiles,
      message: message,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [tiles, message, state];
}

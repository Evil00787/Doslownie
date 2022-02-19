part of 'grid_cubit.dart';

enum GameState { initial, ongoing, won, lost }

class GridState extends Equatable {
  final Point<int> dimensions;
  final List<TileRow> letters;
  final String? message;
  final GameState? state;

  GridState({
    required this.letters,
    required this.dimensions,
    this.message,
    this.state,
  });

  GridState copyWith({
    List<TileRow>? letters,
    String? message,
    GameState? state,
  }) {
    return GridState(
      letters: letters ?? this.letters,
      dimensions: dimensions,
      message: message,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [letters, message, state];
}

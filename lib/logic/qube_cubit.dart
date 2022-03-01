import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/grid.dart';
import '../models/status.dart';

class QubeCubit extends Cubit<GridQubeState> {
  QubeCubit() : super(GridQubeState()) {
    emit(state.copyWith(status: QubeStatus.game));
  }

  void gameFinished() => emit(state.copyWith(status: QubeStatus.qube));

  void changeHighlight(bool increment) {
    var value = state.highlight + (increment ? 1 : -1);
    emit(state.copyWith(highlight: value.clamp(-1, state.games.length - 1)));
  }

  void saveGame(TileGrid tiles) {
    emit(state.copyWith(
      games: [tiles, ...state.games],
      highlight: -1,
    ));
    Future.delayed(
      Duration(milliseconds: 500),
      () => emit(state.copyWith(status: QubeStatus.game)),
    );
  }

  GridStatus getStatus(int index) {
    var inGame = state.status == QubeStatus.game;
    if (inGame && index != -1) return GridStatus.invisible;
    if (index < state.highlight) return GridStatus.invisible;
    var highlighted = index == state.highlight;
    return highlighted ? GridStatus.highlighted : GridStatus.dimmed;
  }

  double getOffset(int index) {
    var offset = (index + 1) * 70.0;
    if (state.status == QubeStatus.qube) offset -= state.highlight * 70;
    return offset;
  }
}

enum QubeStatus { game, qube }

class GridQubeState extends Equatable {
  final List<TileGrid> games;
  final int highlight;
  final QubeStatus? status;

  GridQubeState({this.games = const [], int? highlight, this.status})
      : highlight = highlight ?? games.length - 1;

  GridQubeState copyWith({
    List<TileGrid>? games,
    int? highlight,
    QubeStatus? status,
  }) {
    return GridQubeState(
      games: games ?? this.games,
      highlight: highlight ?? this.highlight,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [games, highlight, status];
}

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../models/grid.dart';
import '../../models/status.dart';
import '../../services/word_repository.dart';
import '../game_config_cubit.dart';
import '../keyboard_cubit.dart';
import '../qube_cubit.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);
  final KeyboardCubit keyboardCubit;
  final GameConfigCubit gameConfigCubit;
  final QubeCubit qubeCubit;
  final _wordRepository = GetIt.I<WordRepository>();
  late String word;

  Point<int> get dimensions => gameConfigCubit.state.dimensions;

  GridCubit(this.gameConfigCubit, this.keyboardCubit, this.qubeCubit)
      : super(GridState(
          tiles: _createTiles(gameConfigCubit.state.dimensions),
          status: GameStatus.ongoing,
        )) {
    _wordRepository.ready.then((_) => _drawWord());
  }

  void letter(String letter) async {
    if (state.status != GameStatus.ongoing) return;
    await _wordRepository.ready;
    if (!_wordRepository.isValidString(letter)) return;
    var gameEnded = pointer.y == dimensions.y;
    if (gameEnded || pointer.x == dimensions.x) return;
    var data = _copyTiles();
    data[pointer.y][pointer.x] = Tile(
      letter: letter.toUpperCase(),
      status: TileStatus.active,
    );
    emit(state.copyWith(tiles: data));
    pointer = Point<int>(pointer.x + 1, pointer.y);
  }

  void confirm() {
    if (state.status != GameStatus.ongoing) return;
    if (pointer.x < dimensions.x) return;
    var input = state.tiles[pointer.y].map((e) => e.letter).join('');
    if (!_wordRepository.isValidWord(input)) {
      emit(state.copyWith(message: 'word.invalid'));
      return;
    }
    var data = _copyTiles();
    var validation = _verifyRow();
    var rowCorrect = validation.every((v) => v == TileStatus.correct);
    GameStatus? newStatus;
    if (rowCorrect) newStatus = GameStatus.won;
    data[pointer.y] = data[pointer.y].copyWith(states: validation);
    keyboardCubit.colorKeyboardKeys(data[pointer.y]);
    if (!rowCorrect) {
      if (pointer.y < dimensions.y - 1) {
        pointer = Point<int>(0, pointer.y + 1);
        var states = List.filled(dimensions.x, TileStatus.active);
        data[pointer.y] = data[pointer.y].copyWith(states: states);
      } else {
        newStatus = GameStatus.lost;
      }
    }
    if (newStatus?.finished ?? false) {
      qubeCubit.gameFinished();
    }
    emit(state.copyWith(tiles: data, status: newStatus));
  }

  List<TileStatus> _verifyRow() {
    var length = dimensions.x;
    List<TileStatus?> result = List.filled(length, null);
    List<bool> used = List.filled(length, false);
    for (var i = 0; i < length; i++) {
      var letter = state.tiles[pointer.y][i].letter;
      if (!word.contains(letter)) {
        result[i] = TileStatus.incorrect;
      } else if (word[i] == letter) {
        result[i] = TileStatus.correct;
        used[i] = true;
      }
    }
    for (var i = 0; i < length; i++) {
      if (result[i] != null) continue;
      for (var j = 0; j < length; j++) {
        if (word[j] == state.tiles[pointer.y][i].letter && !used[j]) {
          result[i] = TileStatus.moved;
          used[j] = true;
          break;
        }
      }
      if (result[i] == null) result[i] = TileStatus.incorrect;
    }
    return result.cast<TileStatus>();
  }

  void clear() {
    if (pointer.x == 0 || state.status != GameStatus.ongoing) return;
    pointer = Point<int>(pointer.x - 1, pointer.y);
    var data = _copyTiles();
    data[pointer.y][pointer.x] = Tile(
      letter: '',
      status: TileStatus.active,
    );
    emit(state.copyWith(tiles: data));
  }

  void startGame() {
    if (state.status != GameStatus.initial) return;
    emit(state.copyWith(status: GameStatus.ongoing));
  }

  void restartGame() {
    if (!state.status.finished) return;
    qubeCubit.saveGame(state.tiles);
    pointer = Point<int>(0, 0);
    _drawWord();
    var data = _createTiles(dimensions);
    keyboardCubit.resetColors();
    emit(state.copyWith(status: GameStatus.ongoing, tiles: data));
  }

  void _drawWord() {
    word = _wordRepository.getRandomWord();
    print('Chosen word: $word');
  }

  TileGrid _copyTiles() => state.tiles.map((e) => e.copyWith()).toList();

  static TileGrid _createTiles(Point<int> dimensions) => [
        for (var y = 0; y < dimensions.y; y++)
          List.filled(
              dimensions.x,
              Tile(
                letter: '',
                status: y == 0 ? TileStatus.active : TileStatus.locked,
              ),
            ),
      ];
}

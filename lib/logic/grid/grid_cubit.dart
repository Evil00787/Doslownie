import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../models/game_state.dart';
import '../../models/grid.dart';
import '../game_config_cubit.dart';
import '../keyboard_cubit.dart';
import '../word_repository.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);
  final KeyboardCubit keyboardCubit;
  final GameConfigCubit gameConfigCubit;
  final _wordRepository = GetIt.I<WordRepository>();
  late String word;

  Point<int> get dimensions => gameConfigCubit.state.dimensions;

  GridCubit(this.gameConfigCubit, this.keyboardCubit)
      : super(GridState(
          tiles: _createTiles(gameConfigCubit.state.dimensions),
          state: GameState.ongoing,
        )) {
    _wordRepository.ready.then((_) => _drawWord());
  }

  void letter(String letter) async {
    if (state.state != GameState.ongoing) return;
    await _wordRepository.ready;
    if (!_wordRepository.isValidString(letter)) return;
    var gameEnded = pointer.y == dimensions.y;
    if (gameEnded || pointer.x == dimensions.x) return;
    var data = _copyTiles();
    data[pointer.y][pointer.x] = Tile(
      letter: letter.toUpperCase(),
      state: TileState.active,
    );
    emit(state.copyWith(tiles: data));
    pointer = Point<int>(pointer.x + 1, pointer.y);
  }

  void confirm() {
    if (state.state != GameState.ongoing) return;
    if (pointer.x < dimensions.x) return;
    var input = state.tiles[pointer.y].map((e) => e.letter).join('');
    if (!_wordRepository.isValidWord(input)) {
      emit(state.copyWith(message: 'Not a valid word'));
      return;
    }
    var data = _copyTiles();
    var validation = _verifyRow();
    var rowCorrect = validation.every((v) => v == TileState.correct);
    GameState? newState;
    if (rowCorrect) newState = GameState.won;
    data[pointer.y] = data[pointer.y].copyWith(states: validation);
    keyboardCubit.colorKeyboardKeys(data[pointer.y]);
    if (!rowCorrect) {
      if (pointer.y < dimensions.y - 1) {
        pointer = Point<int>(0, pointer.y + 1);
        var states = List.filled(dimensions.x, TileState.active);
        data[pointer.y] = data[pointer.y].copyWith(states: states);
      } else {
        newState = GameState.lost;
      }
    }
    emit(state.copyWith(tiles: data, state: newState));
  }

  List<TileState> _verifyRow() {
    var length = dimensions.x;
    List<TileState?> result = List.filled(length, null);
    List<bool> used = List.filled(length, false);
    for (var i = 0; i < length; i++) {
      var letter = state.tiles[pointer.y][i].letter;
      if (!word.contains(letter)) {
        result[i] = TileState.incorrect;
      } else if (word[i] == letter) {
        result[i] = TileState.correct;
        used[i] = true;
      }
    }
    for (var i = 0; i < length; i++) {
      if (result[i] != null) continue;
      for (var j = 0; j < length; j++) {
        if (word[j] == state.tiles[pointer.y][i].letter && !used[j]) {
          result[i] = TileState.moved;
          used[j] = true;
          break;
        }
      }
      if (result[i] == null) result[i] = TileState.incorrect;
    }
    return result.cast<TileState>();
  }

  void clear() {
    if (pointer.x == 0 || state.state != GameState.ongoing) return;
    pointer = Point<int>(pointer.x - 1, pointer.y);
    var data = _copyTiles();
    data[pointer.y][pointer.x] = Tile(
      letter: '',
      state: TileState.active,
    );
    emit(state.copyWith(tiles: data));
  }

  void startGame() {
    if (state.state != GameState.initial) return;
    emit(state.copyWith(state: GameState.ongoing));
  }

  void restartGame() {
    if (state.state != GameState.won && state.state != GameState.lost) return;
    pointer = Point<int>(0, 0);
    _drawWord();
    var data = _createTiles(dimensions);
    keyboardCubit.resetColors();
    emit(state.copyWith(state: GameState.ongoing, tiles: data));
  }

  void _drawWord() {
    word = _wordRepository.getRandomWord();
    print('Chosen word: $word');
  }

  List<List<Tile>> _copyTiles() => state.tiles.map((e) => e.copyWith()).toList();

  static List<List<Tile>> _createTiles(Point<int> dimensions) => [
        for (var y = 0; y < dimensions.y; y++)
          List.filled(
              dimensions.x,
              Tile(
                letter: '',
                state: y == 0 ? TileState.active : TileState.locked,
              ),
            ),
      ];
}

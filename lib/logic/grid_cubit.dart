import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/game_state.dart';
import '../models/grid.dart';
import 'keyboard_cubit.dart';
import 'word_repository.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);
  final KeyboardCubit keyboardCubit;
  final _wordRepository = WordRepository();
  late String word;

  GridCubit(Point<int> dimensions, this.keyboardCubit)
      : super(GridState(
          tiles: _createTiles(dimensions),
          dimensions: dimensions,
          state: GameState.ongoing,
        )) {
    _wordRepository.ready.then((_) => _drawWord());
  }

  void letter(String letter) async {
    if (state.state != GameState.ongoing) return;
    await _wordRepository.ready;
    var gameEnded = pointer.y == state.dimensions.y;
    if (gameEnded || pointer.x == state.dimensions.x) return;
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
    if (pointer.x < state.dimensions.x) return;
    var input = state.tiles[pointer.y].map((e) => e.letter).join('');
    if (!_wordRepository.isValidWord(input, state.dimensions.x)) {
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
      if (pointer.y < state.dimensions.y - 1) {
        pointer = Point<int>(0, pointer.y + 1);
        var states = List.filled(state.dimensions.x, TileState.active);
        data[pointer.y] = data[pointer.y].copyWith(states: states);
      } else {
        newState = GameState.lost;
      }
    }
    emit(state.copyWith(tiles: data, state: newState));
  }

  List<TileState> _verifyRow() {
    var result = <TileState>[];
    for (var i = 0; i < state.dimensions.x; i++) {
      var letter = state.tiles[pointer.y][i].letter;
      if (!word.contains(letter)) {
        result.add(TileState.incorrect);
      } else {
        var placeMatch = word[i] == letter;
        result.add(placeMatch ? TileState.correct : TileState.moved);
      }
    }
    return result;
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
    var data = _createTiles(state.dimensions);
    keyboardCubit.resetColors();
    emit(state.copyWith(state: GameState.ongoing, tiles: data));
  }

  void _drawWord() {
    word = _wordRepository.getRandomWord(state.dimensions.x);
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

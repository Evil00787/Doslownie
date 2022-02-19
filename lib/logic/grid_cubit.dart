import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:doslownie/logic/keyboard_cubit.dart';
import 'package:equatable/equatable.dart';

import '../models/grid.dart';
import 'word_repository.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  var pointer = Point<int>(0, 0);
  final KeyboardCubit keyboardCubit;
  final _wordRepository = WordRepository();
  late String _word;

  GridCubit(Point<int> dimensions, this.keyboardCubit)
      : super(GridState(
          letters: _createTiles(dimensions),
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
    data[pointer.y].tiles[pointer.x] = Tile(letter: letter.toUpperCase());
    emit(state.copyWith(letters: data));
    pointer = Point<int>(pointer.x + 1, pointer.y);
  }

  void confirm() {
    if (state.state != GameState.ongoing) return;
    if (pointer.x < state.dimensions.x) return;
    var input = state.letters[pointer.y].tiles.map((e) => e.letter).join('');
    if (!_wordRepository.isValidWord(input, state.dimensions.x)) {
      emit(state.copyWith(message: 'Not a valid word'));
      return;
    }
    var data = _copyTiles();
    var validation = _verifyRow();
    var rowCorrect = validation.every((v) => v == TileValidation.correct);
    GameState? newState;
    if (rowCorrect) newState = GameState.won;
    data[pointer.y] = data[pointer.y].copyWith(
      validation: validation,
      state: TileRowState.completed,
    );
    keyboardCubit.colorKeyboardKeys(data[pointer.y].tiles);
    if (!rowCorrect) {
      if (pointer.y < state.dimensions.y - 1) {
        pointer = Point<int>(0, pointer.y + 1);
        data[pointer.y] = data[pointer.y].copyWith(state: TileRowState.active);
      } else {
        newState = GameState.lost;
      }
    }
    emit(state.copyWith(letters: data, state: newState));
  }

  List<TileValidation> _verifyRow() {
    var result = <TileValidation>[];
    for (var i = 0; i < state.dimensions.x; i++) {
      var letter = state.letters[pointer.y].tiles[i].letter;
      if (!_word.contains(letter)) {
        result.add(TileValidation.incorrect);
      } else {
        var placeMatch = _word[i] == letter;
        result.add(placeMatch ? TileValidation.correct : TileValidation.moved);
      }
    }
    return result;
  }

  void clear() {
    if (pointer.x == 0 || state.state != GameState.ongoing) return;
    pointer = Point<int>(pointer.x - 1, pointer.y);
    var data = _copyTiles();
    data[pointer.y].tiles[pointer.x] = Tile(letter: '');
    emit(state.copyWith(letters: data));
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
    emit(state.copyWith(state: GameState.ongoing, letters: data));
  }

  void _drawWord() {
    _word = _wordRepository.getRandomWord(state.dimensions.x);
    print('Chosen word: $_word');
  }

  List<TileRow> _copyTiles() => [
        for (var y = 0; y < state.dimensions.y; y++) state.letters[y].copyWith()
      ];

  static List<TileRow> _createTiles(Point<int> dimensions) => [
        for (var y = 0; y < dimensions.y; y++)
          TileRow(
            tiles: List.filled(dimensions.x, Tile(letter: '')),
            state: RowState.fromIndex(y, 0),
          )
      ];
}

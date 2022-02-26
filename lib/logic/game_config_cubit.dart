import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../services/word_repository.dart';
import '../utils/utils.dart';

class GameConfigCubit extends Cubit<GameConfigState> {
  final _wordRepository = GetIt.I<WordRepository>();

  GameConfigCubit()
      : super(GameConfigState(
          locale: Locale('pl', 'PL'),
          dimensions: Point<int>(5, 6),
        )) {
    _update();
    _wordRepository.ready.then(
      (_) => emit(
        state.copyWith(wordLengths: _wordRepository.getSupportedWordLengths()),
      ),
    );
  }

  List<int> get difficultyLevels => 4.to(7);

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
    _update();
  }

  void setWordLength(Point<int> dimensions) {
    emit(state.copyWith(dimensions: dimensions));
    _update();
  }

  void _update() {
    _wordRepository.setLocale(state.locale);
    _wordRepository.setWordLength(state.dimensions.x);
  }
}

class GameConfigState extends Equatable {
  final Locale locale;
  final Point<int> dimensions;
  final List<int>? wordLengths;

  GameConfigState({
    required this.locale,
    required this.dimensions,
    this.wordLengths,
  });

  GameConfigState copyWith({
    Locale? locale,
    Point<int>? dimensions,
    List<int>? wordLengths,
  }) {
    return GameConfigState(
      locale: locale ?? this.locale,
      dimensions: dimensions ?? this.dimensions,
      wordLengths: wordLengths ?? this.wordLengths,
    );
  }

  @override
  List<Object?> get props => [locale, dimensions, wordLengths];
}

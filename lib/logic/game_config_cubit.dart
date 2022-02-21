import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import 'word_repository.dart';

class GameConfigCubit extends Cubit<GameConfigState> {
  final _wordRepository = GetIt.I<WordRepository>();

  GameConfigCubit()
      : super(GameConfigState(
          locale: Locale('pl', 'PL'),
          dimensions: Point<int>(5, 6),
        )) {
    _update();
  }

  void setLocale(Locale locale) {
    emit(GameConfigState(locale: locale, dimensions: state.dimensions));
    _update();
  }

  void setWordLength(Point<int> dimensions) {
    emit(GameConfigState(locale: state.locale, dimensions: dimensions));
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

  GameConfigState({required this.locale, required this.dimensions});

  @override
  List<Object?> get props => [locale, dimensions];
}

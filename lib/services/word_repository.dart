import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

import 'app_locales.dart';

class WordRepository {
  final _words = <Locale, Map<int, List<String>>>{};
  late Locale _locale;
  late int _wordLength;

  List<String> _getList() {
    var list = _words[_locale]?[_wordLength];
    if (list == null) print('Invalid configuration');
    return list ?? [];
  }

  final _completer = Completer();
  Future get ready => _completer.future;

  void setLocale(Locale locale) => _locale = locale;
  void setWordLength(int wordLength) => _wordLength = wordLength;

  static final Map<Locale, RegExp> _validLetters = {
    Locale('en', 'US'): RegExp(r'^[a-zA-Z]*$'),
    Locale('pl', 'PL'): RegExp(r'^[a-zA-ZąćęłóśńżźĄĆĘŁÓŚŃŻŹ]*$'),
  };

  WordRepository() {
    load(Locale e) => rootBundle.loadString('assets/${e.toLanguageTag()}.db');
    Future.wait(AppLocalesDelegate.supportedLocales.map(load)).then((value) {
      for (var i = 0; i < AppLocalesDelegate.supportedLocales.length; i++) {
        _words[AppLocalesDelegate.supportedLocales[i]] = _loadWords(value[i]);
      }
      _completer.complete();
    });
  }

  bool isValidString(String string) => _validLetters[_locale]!.hasMatch(string);

  Map<int, List<String>> _loadWords(String l) {
    var words = l.replaceAll("\r", "").split('\n').where(isValidString).map((e) => e.toUpperCase());
    return _groupBy<String, int>(words, (p0) => p0.length);
  }

  String getRandomWord() {
    var list = _getList();
    if (list.isEmpty) return '';
    return list[Random().nextInt(list.length)];
  }

  bool isValidWord(String word) => _getList().contains(word);

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

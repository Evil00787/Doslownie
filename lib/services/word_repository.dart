import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

import 'app_locales.dart';

typedef WordList = List<String>;
typedef Dictionary = Map<int, WordList>;
typedef DictionarySet = Map<DictionaryType, Dictionary>;

class WordRepository {
  final _words = <Locale, DictionarySet>{};
  late Locale _locale;
  late int _wordLength;

  List<String> _getDictionary(DictionaryType type) {
    var list = _words[_locale]?[type]?[_wordLength];
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
    var locales = AppLocalesDelegate.supportedLocales;
    var entryFuture = Future.wait(locales.map((l) => _loadLocale(l)));
    entryFuture.then((entries) {
      _words.addEntries(entries);
      _completer.complete();
    });
  }

  Future<MapEntry<Locale, DictionarySet>> _loadLocale(Locale l) async {
    var types = DictionaryType.values.map((t) => _loadDictionary(l, t));
    return Future.wait(types).then((map) => MapEntry(l, Map.fromEntries(map)));
  }

  Future<MapEntry<DictionaryType, Dictionary>> _loadDictionary(
      Locale l, DictionaryType t) async {
    var file = await rootBundle.loadString(t.asset(l));
    var words = file
        .replaceAll("\r", "")
        .split('\n')
        .where((w) => isValidString(w, l) && w.isNotEmpty)
        .map((e) => e.toUpperCase());
    return MapEntry(t, _groupBy<String, int>(words, (p0) => p0.length));
  }

  bool isValidString(String string, [Locale? locale]) {
    return _validLetters[locale ?? _locale]!.hasMatch(string);
  }

  String getRandomWord() {
    var list = _getDictionary(DictionaryType.basic);
    if (list.isEmpty) return '';
    return list[Random().nextInt(list.length)];
  }

  List<int>? getSupportedWordLengths() =>
      _words[_locale]?[DictionaryType.basic]?.keys.toList();

  bool isValidWord(String word) =>
      _getDictionary(DictionaryType.extended).contains(word);

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

enum DictionaryType { basic, extended }

extension DictionaryAsset on DictionaryType {
  String asset(Locale locale) => {
        DictionaryType.extended: 'assets/${locale.toLanguageTag()}_extended.db',
        DictionaryType.basic: 'assets/${locale.toLanguageTag()}.db'
      }[this]!;
}

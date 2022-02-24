import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;

import 'app_locales.dart';

class WordRepository {
  final _words = <Locale, Map<ListType, Map<int, List<String>>>>{};
  Locale? _locale;
  late int _wordLength;

  List<String> _getList({ListType type = ListType.inputList}) {
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
    load(Locale e) => {
      ListType.inputList: rootBundle.loadString('assets/${e.toLanguageTag()}.db'),
      ListType.riddleList: rootBundle.loadString('assets/riddle-${e.toLanguageTag()}.db')
    };

    var timer;
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      if (_locale != null) {
        var localesDelegate = AppLocalesDelegate.supportedLocales.map(load).toList();

        for (var i = 0; i < localesDelegate.length; i++) {
          _words[AppLocalesDelegate.supportedLocales[i]] = {ListType.inputList: {0: []}, ListType.riddleList: {0: []}};
        }
        Future.wait<void>([
          for (var i = 0; i < localesDelegate.length; i++)
            localesDelegate[i][ListType.inputList]!.then((value) {
              _words[AppLocalesDelegate.supportedLocales[i]]?[ListType.inputList] = _loadWords(value);
            }),
          for (var i = 0; i < localesDelegate.length; i++)
            localesDelegate[i][ListType.riddleList]!.then((value) {
              _words[AppLocalesDelegate.supportedLocales[i]]?[ListType.riddleList]= _loadWords(value);
            })
        ]).whenComplete(() {
          _completer.complete();
        });
        timer.cancel();
      }
    });

  }

  bool isValidString(String string) => _validLetters[_locale]!.hasMatch(string);

  Map<int, List<String>> _loadWords(String l) {
    var words = l.replaceAll("\r", "").split('\n').where(isValidString).map((e) => e.toUpperCase());
    return _groupBy<String, int>(words, (p0) => p0.length);
  }

  String getRandomWord() {
    var list = _getList(type: ListType.riddleList);
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

enum ListType {
  riddleList, inputList
}

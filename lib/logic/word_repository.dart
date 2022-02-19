import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class WordRepository {
  final _words = <int, List<String>>{};

  final _completer = Completer();
  Future get ready => _completer.future;

  WordRepository() {
    rootBundle.loadString('assets/words.db').then((db) {
      var words = db.split('\n').map((e) => e.replaceAll("\r", "").toUpperCase());
      _words.addAll(_groupBy<String, int>(words, (p0) => p0.length));
      _completer.complete();
    });
  }

  String getRandomWord(int length) {
    if (!_words.containsKey(length)) return '';
    return _words[length]![Random().nextInt(_words[length]!.length)];
  }

  bool isValidWord(String word, int length) {
    if (!_words.containsKey(length)) return false;
    return _words[length]!.contains(word);
  }

  Map<T, List<S>> _groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

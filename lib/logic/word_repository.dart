import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

class WordRepository {
  final List<String> _words = [];

  final _completer = Completer();
  Future get ready => _completer.future;

  WordRepository() {
    rootBundle.loadString('assets/words.db').then((db) {
      _words.addAll(db.split('\n').map((e) => e.toUpperCase()));
      _completer.complete();
    });
  }

  String getRandomWord() => _words[Random().nextInt(_words.length)];

  bool isValidWord(String word) => _words.contains(word);
}

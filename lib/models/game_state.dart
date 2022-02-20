import 'package:flutter/material.dart';

enum GameState { initial, ongoing, won, lost }

extension GameStateMessage on GameState {
  String get message => const {
    GameState.initial: 'New game',
    GameState.ongoing: 'Game started',
    GameState.won: 'You won!',
    GameState.lost: 'Game over',
  }[this]!;

  IconData get icon => const {
    GameState.initial: Icons.not_started_rounded,
    GameState.ongoing: Icons.play_arrow_rounded,
    GameState.won: Icons.emoji_events_rounded,
    GameState.lost: Icons.clear_rounded,
  }[this]!;
}
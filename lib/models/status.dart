enum GameStatus { initial, ongoing, won, lost }

extension GameStatusGroups on GameStatus {
  bool get finished => [GameStatus.won, GameStatus.lost].contains(this);
}

enum GridStatus { highlighted, dimmed, invisible }

extension GridStatusUtils on GridStatus {
  double get opacity => {
    GridStatus.dimmed: .1,
    GridStatus.highlighted: 1.0,
    GridStatus.invisible: 0.0,
  }[this]!;
}

enum TileStatus { incorrect, moved, correct, unknown, active, locked }

extension TileGroups on TileStatus {
  bool get uncovered => [TileStatus.incorrect, TileStatus.moved, TileStatus.correct].contains(this);
}

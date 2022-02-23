import 'package:flutter/material.dart';

import '../../models/game_state.dart';
import '../../models/grid.dart';
import '../grid/letter_cell.dart';
import '../main_action_button.dart';

class EndGameDialog extends StatelessWidget {
  final GameState gameState;
  final void Function() startNewGame;
  final String hiddenWord;

  const EndGameDialog({
    Key? key,
    required this.gameState,
    required this.startNewGame,
    required this.hiddenWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: Center(
        child: Text(
          gameState == GameState.won
              ? "Sukces!".toUpperCase()
              : "Przegrana :(".toUpperCase(),
          style: TextStyle(fontSize: 32),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "Ukryte słowo: ",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var letter in hiddenWord.characters)
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: LetterCell(
                          tile: Tile(
                            letter: letter,
                            state: TileState.correct,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) => [
        Center(
          child: MainActionButton("NOWA GRA", () {
            startNewGame();
            Navigator.of(context).pop();
          }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 24.0,
                ),
                child: Text(
                  "ZAMKNIJ",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ),
        )
      ];
}

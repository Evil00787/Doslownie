import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/game_state.dart';
import '../../models/grid.dart';
import '../../services/app_locales.dart';
import '../grid/letter_cell.dart';
import '../main_action_button.dart';

class EndGameDialog extends StatelessWidget {
  final GameState gameState;
  final void Function() startNewGame;
  final String hiddenWord;
  final String languageString;

  const EndGameDialog({
    Key? key,
    required this.languageString,
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
              ? AppLocales.I('game.won').toUpperCase()
              : AppLocales.I('game.lost').toUpperCase(),
          style: TextStyle(fontSize: 32),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                "${AppLocales.I('word.hidden')}: ",
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
          child: MainActionButton(AppLocales.I('game.new').toUpperCase(), () {
            startNewGame();
            Navigator.of(context).pop();
          }),
        ),
        Center(
          child: MainActionButton(AppLocales.I('whats_that').toUpperCase(), () async {
            if (!await launch(AppLocales.I('dict_url') + Uri.encodeFull(hiddenWord[0].toUpperCase() + (hiddenWord.length > 1 ? hiddenWord.substring(1).toLowerCase() : "")))) {
              throw 'Could not launch';
            }
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
                  AppLocales.I('close').toUpperCase(),
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ),
        )
      ];
}

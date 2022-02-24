import 'package:flutter/material.dart';

import '../logic/grid/grid_cubit.dart';
import '../models/game_state.dart';
import '../services/app_locales.dart';
import 'dialogs/game_dialogs.dart';

class CustomAppBar extends StatelessWidget {
  final GridState? state;
  const CustomAppBar({this.state});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(AppLocales.I('title')),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          state != null && (state?.state == GameState.won || state?.state == GameState.lost)
              ? IconButton(
            onPressed: () => GameDialogs.showEndGameDialog(
              context,
              state!.state!,
              noDelay: true,
            ),
            icon: Icon(Icons.restart_alt),
          )
              : SizedBox.shrink()
        ],
      );
  }
}

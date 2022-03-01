import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/grid/grid_cubit.dart';
import '../../services/app_locales.dart';

class GameDialogs extends StatelessWidget {
  final Widget child;

  GameDialogs({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GridCubit, GridState>(
      listenWhen: (oldState, newState) => newState.message != null,
      listener: (context, state) => _showFlushbar(
        message: AppLocales.I(state.message!),
        context: context,
        icon: Icons.warning_rounded,
      ),
      child: child,
    );
  }

  void _showFlushbar({
    required String message,
    required BuildContext context,
    IconData? icon,
  }) {
    var accentColor = Theme.of(context).colorScheme.secondary;
    Flushbar(
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.all(4),
      duration: Duration(seconds: 5),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      borderRadius: BorderRadius.circular(8),
      icon: icon != null ? Icon(icon, size: 28.0, color: accentColor) : null,
      leftBarIndicatorColor: accentColor,
    ).show(context);
  }
}

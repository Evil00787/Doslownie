import 'package:doslownie/widgets/keyboard_button.dart';
import 'package:flutter/material.dart';

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var a in "ĄĆĘŁÓŚŃŻŹ".characters) KeyboardButton(a)]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var a in "QWERTYUIOP".characters) KeyboardButton(a)]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var a in "ASDFGHJKL".characters) KeyboardButton(a)]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var a in "ZXCVBNM".characters) KeyboardButton(a)]),
      ],
    );
  }
}

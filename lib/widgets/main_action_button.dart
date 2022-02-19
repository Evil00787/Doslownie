import 'package:flutter/material.dart';

class MainActionButton extends StatelessWidget {
  const MainActionButton(this.title, this.onPressed, {Key? key}) : super(key: key);

  final Function onPressed;
  final String title;



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Text(title),
        )
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamePage extends StatefulWidget {
  final Point<int> dimensions;

  GamePage({required this.dimensions});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<List<String>> letters;
  var pointer = Point<int>(0, 0);

  @override
  void initState() {
    super.initState();
    letters = List.generate(
      widget.dimensions.y,
      (_) => List.filled(widget.dimensions.x, ''),
    );
    RawKeyboard.instance.addListener((event) {
      if (event is RawKeyDownEvent && event.character != null) {
        setState(() {
          letters[pointer.y][pointer.x] = event.character!;
          pointer = pointer.x < widget.dimensions.x - 1
              ? Point<int>(pointer.x + 1, pointer.y)
              : Point<int>(0, pointer.y + 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var y = 0; y < widget.dimensions.y; y++)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var x = 0; x < widget.dimensions.x; x++)
              buildCell(Point<int>(x, y)),
          ]),
      ]),
    );
  }

  Padding buildCell(Point<int> position) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: 50,
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              letters[position.y][position.x],
              style: TextStyle(
                fontSize: 25,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

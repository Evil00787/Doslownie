import 'package:flutter/material.dart';

import '../models/grid.dart';
import 'flip_view.dart';
import 'letter_cell.dart';

class AnimatedTile extends StatefulWidget {
  final Tile tile;
  final Duration delay;
  final Duration animationTime;

  const AnimatedTile({
    required this.tile,
    required this.delay,
    required this.animationTime,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedTileState createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _curvedAnimation;
  late Tile _currentTile;
  bool _currentFront = true;
  
  @override
  void initState() {
    super.initState();

    _currentTile = widget.tile;
    _animCtrl = AnimationController(
      vsync: this,
      duration: widget.animationTime,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.state.uncovered && _animCtrl.value == 0) {
      Future.delayed(widget.delay, () => _animCtrl.forward().then(_switchSides));
    } else if (!widget.tile.state.uncovered && _animCtrl.value == 1) {
      Future.delayed(widget.delay, () => _animCtrl.reverse().then(_switchSides));
    } else {
      _currentTile = widget.tile;
    }
    return FlipView(
      animationController: _curvedAnimation,
      front: LetterCell(tile: _getTile(front: true), animationTime: widget.animationTime),
      back: LetterCell(tile: _getTile(front: false), animationTime: widget.animationTime),
    );
  }

  void _switchSides(_) {
    _currentTile = widget.tile;
    _currentFront = !_currentFront;
  }

  Tile _getTile({required bool front}) {
    return front == _currentFront ? _currentTile : widget.tile;
  }
}

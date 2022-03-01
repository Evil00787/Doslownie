import 'package:flutter/material.dart';

class AnimatedValue<Type> extends StatefulWidget {
  final Duration duration;
  final Widget Function(Type value) builder;
  final Curve curve;
  final Type value;

  AnimatedValue({
    required this.value,
    required this.builder,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeInOut,
  });

  @override
  _AnimatedValueState<Type> createState() => _AnimatedValueState<Type>();
}

class _AnimatedValueState<Type> extends State<AnimatedValue<Type>> {
  Type? value;

  Tween<Type?> get _tween {
    value ??= widget.value;
    if (Type == Color) {
      return ColorTween(
        begin: value as Color?,
        end: widget.value as Color?,
      ) as Tween<Type?>;
    }
    return Tween<Type?>(begin: value, end: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Type?>(
      tween: _tween,
      onEnd: () => setState(() => value = widget.value),
      duration: widget.duration,
      curve: widget.curve,
      builder: (_, value, __) => widget.builder(value!),
    );
  }
}

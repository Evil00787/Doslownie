import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

class CubitUtils {
  static Widget withCubit<T extends Cubit>(Widget widget, Create<T> cubit) {
    return BlocProvider<T>(
      create: cubit,
      child: widget,
    );
  }
}

extension RangeExtension on int {
  List<int> to(int maxInclusive, {int step = 1}) =>
      [for (int i = this; i <= maxInclusive; i += step) i];
}

extension Group<S> on Iterable<S> {
  Map<T, List<S>> groupBy<T>(T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }
}

extension Rotations on Matrix4 {
  Matrix4 rotateGlob(Vector3 axis, double angle) {
    return this..rotate(absoluteRotate(axis), angle);
  }
  Matrix4 rotateGlobX(double angle) {
    return this..rotate(right, angle);
  }
}

extension ColorUtils on Color {
  Color multiplyOpacity(double opacity) => withOpacity(this.opacity * opacity);
}

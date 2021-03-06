import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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

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
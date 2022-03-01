import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../logic/grid/grid_cubit.dart';
import '../../logic/qube_cubit.dart';
import '../../models/grid.dart';
import '../../models/status.dart';
import '../../utils/utils.dart';
import '../grid/game_grid.dart';
import 'animated_value.dart';

class QubeView extends StatelessWidget {
  Matrix4 get _baseMatrix => Matrix4.identity()..setEntry(3, 2, 0.002);

  Matrix4 _newMatrix(QubeStatus? status) {
    return status == QubeStatus.qube
        ? (_baseMatrix
          ..rotateGlob(Vector3(0, 1, 0), .8)
          ..rotateGlob(Vector3(1, 0, 0), .3))
        : _baseMatrix;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QubeCubit, GridQubeState>(
      builder: (context, state) {
        var newMatrix = _newMatrix(state.status);
        return AnimatedValue<Matrix4>(
          value: newMatrix,
          curve: Curves.easeInOut,
          duration: Duration(seconds: 2),
          builder: (value) => Transform(
            transform: value,
            alignment: FractionalOffset.center,
            child: _buildQube(context, state),
          ),
        );
      },
    );
  }

  Widget _buildGrid({
    required TileGrid grid,
    required GridStatus status,
    required double offset,
  }) {
    return AnimatedValue<double>(
      value: offset,
      builder: (value) => Transform(
        transform: Matrix4.translation(Vector3(0, 0, value)),
        child: AnimatedValue<double>(
          value: status.opacity,
          duration: Duration(milliseconds: 500),
          builder: (value) => GameGrid(
            grid: grid,
            opacity: value,
          ),
        ),
      ),
    );
  }

  Widget _buildQube(BuildContext context, GridQubeState state) {
    var cubit = context.read<QubeCubit>();
    return BlocBuilder<GridCubit, GridState>(
      builder: (context, gridState) => Stack(
      children: [
        for (var i = 0; i < state.games.length; i++)
          _buildGrid(
            grid: state.games[i],
            status: cubit.getStatus(i),
            offset: cubit.getOffset(i),
          ),
        _buildGrid(
            grid: gridState.tiles,
            status: cubit.getStatus(-1),
            offset: cubit.getOffset(-1),
          ),
        ],
      )
    );
  }
}

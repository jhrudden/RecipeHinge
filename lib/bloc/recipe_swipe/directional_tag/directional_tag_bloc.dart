import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'directional_tag_event.dart';
part 'directional_tag_state.dart';

enum SwipeDirection { left, right, none }

class DirectionalTagBloc
    extends Bloc<DirectionalTagEvent, DirectionalTagState> {
  double _dx = 0.0;

  DirectionalTagBloc() : super(NoDirection());

  @override
  Stream<DirectionalTagState> mapEventToState(
    DirectionalTagEvent event,
  ) async* {
    if (event is ResetPosition) {
      _dx = 0.0;
      yield NoDirection();
    } else if (event is UpdatePosition) {
      _dx = _dx + event.changeInX;
      if (_dx > 0) {
        yield Right();
      } else if (_dx < 0) {
        yield Left();
      } else {
        yield NoDirection();
      }
    }
  }
}

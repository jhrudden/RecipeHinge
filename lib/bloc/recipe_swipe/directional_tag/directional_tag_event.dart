part of 'directional_tag_bloc.dart';

abstract class DirectionalTagEvent extends Equatable {
  const DirectionalTagEvent();

  @override
  List<Object> get props => [];
}

class UpdatePosition extends DirectionalTagEvent {
  final double changeInX;

  UpdatePosition(this.changeInX);

  @override
  List<Object> get props => [changeInX];
}

class ResetPosition extends DirectionalTagEvent {}

part of 'directional_tag_bloc.dart';

abstract class DirectionalTagState extends Equatable {
  const DirectionalTagState();

  @override
  List<Object> get props => [];
}

class NoDirection extends DirectionalTagState {}

class Left extends DirectionalTagState {}

class Right extends DirectionalTagState {}

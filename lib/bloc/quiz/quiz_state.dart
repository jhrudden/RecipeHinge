part of 'quiz_bloc.dart';

@immutable
abstract class QuizState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class Loading extends QuizState {}

class RetrievedCard extends QuizState {
  final QuizCardCombo combo;

  RetrievedCard({@required this.combo});

  @override
  List<Object> get props => [combo];
}

class LoadedTags extends QuizState {
  final List<String> tags;

  LoadedTags({@required this.tags});

  @override
  List<Object> get props => [tags];
}

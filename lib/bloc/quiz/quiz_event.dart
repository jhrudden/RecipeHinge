part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BuildQuiz extends QuizEvent {}

class GetQuestionCard extends QuizEvent {}

class SaveTag extends QuizEvent {
  final String tag;

  SaveTag({@required this.tag});

  @override
  List<Object> get props => [tag];
}

class GetTags extends QuizEvent {}

class RemoveTags extends QuizEvent {
  final List<String> toRemove;

  RemoveTags({@required this.toRemove});

  @override
  List<Object> get props => [toRemove];
}

class SaveTags extends QuizEvent {}

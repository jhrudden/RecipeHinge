import 'package:equatable/equatable.dart';

class QuizCard extends Equatable {
  final String question;
  final List<String> answers;
  QuizCard._({this.question, List<String> answers})
      : assert(answers != null),
        answers = answers;

  factory QuizCard.fromMap(Map<String, dynamic> questionMap) {
    String question = questionMap['question'] as String;
    List<dynamic> nonTypedTags = questionMap['answers'];
    List<String> tags = [];
    for (dynamic s in nonTypedTags) {
      tags.add(s as String);
    }
    return QuizCard._(question: question, answers: tags);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> quizCard = {
      'question': question,
      'answers': answers,
    };
    return quizCard;
  }

  @override
  List<Object> get props => [question, answers];

  @override
  String toString() => 'QuizCard{question: $question, tags = $answers}';
}

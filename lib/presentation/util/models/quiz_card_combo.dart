import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:recipe_hinge/models/quiz_card.dart';

/// Object used to encapsolute both a question card and a double repesenting how
/// much of the quiz we have completed
class QuizCardCombo extends Equatable {
  final QuizCard card;
  final double percentDone;

  QuizCardCombo({@required this.card, @required this.percentDone});

  @override
  List<Object> get props => [this.card, this.percentDone];
}

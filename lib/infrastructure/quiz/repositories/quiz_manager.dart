import 'dart:math';

import 'package:flutter/material.dart';

import '../../../models/quiz_card.dart';
import '../../overall/repositories/question_data_service.dart';
import '../../overall/repositories/user_data_service.dart';

/// TODO: Maybe structure a quiz as levels based on depth of questions
///     OuterLevel -> more broad
///     InnerLevels -> Exceedingly more specific.
class QuizManager {
  final QuestionDataService _questionDataService;
  final UserDataService _userDataService;
  final List<QuizCard> _quizCards = [];
  int currentCardIndex = 0;
  final Set<String> _savedTags = Set();

  QuizManager(
      {@required UserDataService userDataService,
      @required QuestionDataService data})
      : assert(data != null),
        assert(userDataService != null),
        _userDataService = userDataService,
        _questionDataService = data;

  // return next card to be displayed and increase currentIndex in quiz
  QuizCard nextCard() {
    if (currentCardIndex < _quizCards.length) {
      QuizCard card = _quizCards[currentCardIndex];
      currentCardIndex++;
      return card;
    }
    return null;
  }

  /// how far are we into the quiz?
  double get quizProgress => currentCardIndex / _quizCards.length.toDouble();

  /// Propagates [quizCards] by randomly selecting 6 (or less if there aren't
  /// six in database) question documents from database and translating data
  /// into quizCards.
  Future<void> buildQuestions() async {
    final rand = Random();

    List<QuizCard> allQuestionCards =
        await _questionDataService.allQuestionCards;
    List<QuizCard> processedCards = await _userDataService.userProcessQuestions;
    allQuestionCards = allQuestionCards
        .where((element) => !processedCards.contains(element))
        .toList();
    final int lengthOfQuestionDir = allQuestionCards.length;

    final questionCardsLength =
        (lengthOfQuestionDir < 6) ? lengthOfQuestionDir : 6;

    Set<int> randomIndices = Set();

    while (randomIndices.length < questionCardsLength) {
      randomIndices.add(rand.nextInt(lengthOfQuestionDir));
    }

    for (int index in randomIndices) {
      _quizCards.add(allQuestionCards[index]);
    }
  }

  /// Add a given string to our set of tags.
  void addTag(String tag) {
    _savedTags.add(tag);
  }

  /// convert set of saved tags to list then return it.
  List<String> getTags() {
    return _savedTags.toList();
  }

  /// remove all tags from the given list that exist in our tag set.
  void removeTags(List<String> toRemove) {
    for (String tag in toRemove) {
      _savedTags.remove(tag);
    }
  }

  // gets a list of all process questions who has tags currently appearing
  // in savedTags field
  List<QuizCard> get processedQuestions {
    List<QuizCard> processedQuestions = _quizCards.where((element) {
      for (String tag in _savedTags) {
        if (element.answers.contains(tag)) return true;
      }
      return false;
    }).toList();
    return processedQuestions;
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../infrastructure/overall/repositories/database.dart';
import '../../infrastructure/overall/repositories/user_data_service.dart';
import '../../infrastructure/quiz/repositories/quiz_manager.dart';
import '../../presentation/util/models/quiz_card_combo.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final UserDataService _userDataService;
  final QuizManager _quizManager;
  QuizBloc({DatabaseService repository})
      : assert(repository != null),
        _userDataService = repository.buildUserDataService(),
        _quizManager = QuizManager(
            userDataService: repository.buildUserDataService(),
            data: repository.buildQuestionDataService()),
        super(QuizInitial());

  @override
  Stream<QuizState> mapEventToState(
    QuizEvent event,
  ) async* {
    if (event is BuildQuiz) {
      yield Loading();
      await _quizManager.buildQuestions();
      yield (RetrievedCard(
          combo: QuizCardCombo(
              card: _quizManager.nextCard(),
              percentDone: _quizManager.quizProgress)));
    } else if (event is GetQuestionCard) {
      yield (RetrievedCard(
          combo: QuizCardCombo(
              card: _quizManager.nextCard(),
              percentDone: _quizManager.quizProgress)));
    } else if (event is SaveTag) {
      _quizManager.addTag(event.tag);
      yield (RetrievedCard(
          combo: QuizCardCombo(
              card: _quizManager.nextCard(),
              percentDone: _quizManager.quizProgress)));
    } else if (event is GetTags) {
      yield (LoadedTags(tags: _quizManager.getTags()));
    } else if (event is RemoveTags) {
      _quizManager.removeTags(event.toRemove);
      yield (LoadedTags(tags: _quizManager.getTags()));
    } else if (event is SaveTags) {
      await _userDataService
          .saveProcessedQuestions(_quizManager.processedQuestions);
      await _userDataService.addUserTags(_quizManager.getTags());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/quiz_card.dart';
import 'database.dart';

class QuestionDataService {
  final DatabaseService _dataBase;

  QuestionDataService._(this._dataBase);

  factory QuestionDataService.build(DatabaseService data) {
    assert(data != null);
    return QuestionDataService._(data);
  }

  // get questions snapshot
  Future<QuerySnapshot> get questions async {
    return await _dataBase.questionCollection.get();
  }

  Future<List<QuizCard>> get allQuestionCards async {
    List<QuizCard> result = [];
    List<DocumentSnapshot> allQuestions =
        await this.questions.then((value) => value.docs);
    for (DocumentSnapshot ref in allQuestions) {
      result.add(QuizCard.fromMap(ref.data()));
    }
    return result;
  }
}

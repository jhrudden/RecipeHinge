import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'question_data_service.dart';
import 'recipe_data_service.dart';
import 'user_data_service.dart';

class DatabaseService {
  /// user id
  final String uid;

  DatabaseService({@required this.uid}) : assert(uid != null);

  /// Collection References
  CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  FirebaseFirestore instance = FirebaseFirestore.instance;

  CollectionReference questionCollection =
      FirebaseFirestore.instance.collection('questions');

  CollectionReference recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  UserDataService buildUserDataService() {
    return UserDataService.build(this, uid);
  }

  QuestionDataService buildQuestionDataService() {
    return QuestionDataService.build(this);
  }

  RecipeDataService buildRecipeDataService() {
    return RecipeDataService.build(this);
  }
}

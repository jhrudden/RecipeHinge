import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/recipe_card.dart';
import 'database.dart';

class RecipeDataService {
  final DatabaseService _dataBase;

  RecipeDataService._(this._dataBase);

  factory RecipeDataService.build(DatabaseService data) {
    assert(data != null);
    return RecipeDataService._(data);
  }

  // get recipe snapshot
  Future<QuerySnapshot> get recipes async {
    return await _dataBase.recipesCollection.get();
  }

  Future<List<RecipeCard>> get allRecipeCards async {
    List<RecipeCard> cards = [];
    List<QueryDocumentSnapshot> recipes =
        await this.recipes.then((value) => value.docs);
    for (QueryDocumentSnapshot snap in recipes) {
      cards.add(RecipeCard.fromMap(snap.data()));
    }

    return cards;
  }
}

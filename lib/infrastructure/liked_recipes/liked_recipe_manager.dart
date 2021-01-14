import 'dart:core';

import 'package:flutter/cupertino.dart';

import '../../models/recipe_card.dart';
import '../overall/repositories/user_data_service.dart';

class LikedRecipeManager {
  final UserDataService _userDataService;
  List<RecipeCard> _likedRecipes = [];
  LikedRecipeManager({@required UserDataService userDataService})
      : assert(userDataService != null),
        _userDataService = userDataService;

  Future init() async {
    _likedRecipes.addAll(await _userDataService.likedRecipes);
  }

  List<RecipeCard> get likedRecipes {
    return List.of(_likedRecipes);
  }

  Future<void> removeCardFromLiked(RecipeCard recipe) async {
    _likedRecipes.remove(recipe);
    await _userDataService.saveProcessedRecipe(recipe);
    await _userDataService.updateUserRecipes(_likedRecipes);
  }
}

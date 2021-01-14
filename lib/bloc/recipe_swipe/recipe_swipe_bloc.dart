import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/recipe_swipe/repository/recipe_swipe_manager.dart';
import '../../models/recipe_card.dart';
import '../../infrastructure/overall/repositories/database.dart';

part 'recipe_swipe_event.dart';
part 'recipe_swipe_state.dart';

class RecipeSwipeBloc extends Bloc<RecipeSwipeEvent, RecipeSwipeState> {
  final RecipeSwipeManager _recipeSwipeManager;
  RecipeSwipeBloc({DatabaseService repository})
      : assert(repository != null),
        _recipeSwipeManager = RecipeSwipeManager(
            userData: repository.buildUserDataService(),
            recipeData: repository.buildRecipeDataService()),
        super(EmptyDeck());

  @override
  Stream<RecipeSwipeState> mapEventToState(
    RecipeSwipeEvent event,
  ) async* {
    if (event is GetRecipeDeck) {
      yield LoadingDeck();
      await _recipeSwipeManager.buildRecipeDeck();
      yield LoadedCard(card: _recipeSwipeManager.getFirst());
    } else if (event is SaveRecipe) {
      await _recipeSwipeManager.saveRecipe(_recipeSwipeManager.getFirst());
      await _recipeSwipeManager.popRecipe();
      yield LoadedCard(card: _recipeSwipeManager.getFirst());
    } else if (event is PassRecipe) {
      RecipeCard removed = await _recipeSwipeManager.popRecipe();
      yield LoadedCard(card: _recipeSwipeManager.getFirst());
      await _recipeSwipeManager.saveProcessedRecipe(removed);
    }
  }
}

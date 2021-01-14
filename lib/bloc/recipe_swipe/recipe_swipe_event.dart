part of 'recipe_swipe_bloc.dart';

abstract class RecipeSwipeEvent extends Equatable {
  const RecipeSwipeEvent();

  @override
  List<Object> get props => [];
}

class GetRecipeDeck extends RecipeSwipeEvent {}

class SaveRecipe extends RecipeSwipeEvent {}

class PassRecipe extends RecipeSwipeEvent {}

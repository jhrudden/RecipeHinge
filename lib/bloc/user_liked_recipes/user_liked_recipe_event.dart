part of 'user_liked_recipe_bloc.dart';

abstract class UserLikedRecipeEvent extends Equatable {
  const UserLikedRecipeEvent();

  @override
  List<Object> get props => [];
}

class GetUsersLikedRecipes extends UserLikedRecipeEvent {}

class RemoveUserRecipe extends UserLikedRecipeEvent {
  final RecipeCard cardToRemove;

  RemoveUserRecipe({@required this.cardToRemove});

  @override
  List<Object> get props => [cardToRemove];
}

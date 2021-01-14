part of 'user_liked_recipe_bloc.dart';

abstract class UserLikedRecipeState extends Equatable {
  const UserLikedRecipeState();

  @override
  List<Object> get props => [];
}

class Initial extends UserLikedRecipeState {}

class LoadingRecipes extends UserLikedRecipeState {}

class LoadedRecipes extends UserLikedRecipeState {
  final List<RecipeCard> likedRecipes;

  LoadedRecipes({@required this.likedRecipes});

  @override
  List<Object> get props => [likedRecipes];
}

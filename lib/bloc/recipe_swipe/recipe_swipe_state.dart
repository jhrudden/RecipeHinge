part of 'recipe_swipe_bloc.dart';

abstract class RecipeSwipeState extends Equatable {
  const RecipeSwipeState();

  @override
  List<Object> get props => [];
}

class EmptyDeck extends RecipeSwipeState {}

class LoadingDeck extends RecipeSwipeState {}

class LoadedCard extends RecipeSwipeState {
  final RecipeCard card;

  LoadedCard({@required this.card});

  @override
  List<Object> get props => [card];
}

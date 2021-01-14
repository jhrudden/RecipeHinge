import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/liked_recipes/liked_recipe_manager.dart';
import '../../infrastructure/overall/repositories/database.dart';
import '../../models/recipe_card.dart';

part 'user_liked_recipe_event.dart';
part 'user_liked_recipe_state.dart';

class UserLikedRecipeBloc
    extends Bloc<UserLikedRecipeEvent, UserLikedRecipeState> {
  final LikedRecipeManager _likedRecipeManager;

  UserLikedRecipeBloc({@required DatabaseService data})
      : assert(data != null),
        _likedRecipeManager =
            LikedRecipeManager(userDataService: data.buildUserDataService()),
        super(Initial());

  @override
  Stream<UserLikedRecipeState> mapEventToState(
    UserLikedRecipeEvent event,
  ) async* {
    if (event is GetUsersLikedRecipes) {
      yield LoadingRecipes();
      await _likedRecipeManager.init();
      yield LoadedRecipes(likedRecipes: _likedRecipeManager.likedRecipes);
    } else if (event is RemoveUserRecipe) {
      await _likedRecipeManager.removeCardFromLiked(event.cardToRemove);
    }
  }
}

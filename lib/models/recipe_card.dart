import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RecipeCard extends Equatable {
  final String recipeName;
  final String imageName;
  final List<String> recipeTags;
  final String recipeDescription;

  RecipeCard._(
      {@required this.recipeName,
      @required this.imageName,
      @required this.recipeTags,
      @required this.recipeDescription});

  factory RecipeCard.fromMap(Map<String, dynamic> recipeMap) {
    String recipeName = recipeMap['title'] as String;
    String imageName = recipeMap['imageName'] as String;
    List<dynamic> tags = recipeMap['tags'];
    String recipeDescription = recipeMap['recipeDescription'];
    List<String> castedTags = tags.cast<String>();
    return RecipeCard._(
        recipeName: recipeName,
        imageName: imageName,
        recipeTags: castedTags,
        recipeDescription: recipeDescription);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> recipe = {
      'title': recipeName,
      'imageName': imageName,
      'tags': recipeTags,
      'recipeDescription': recipeDescription
    };
    return recipe;
  }

  @override
  String toString() {
    return 'RecipeCard {recipeName: $recipeName, recipeImageUrl: $imageName, recipeTags: $recipeTags';
  }

  @override
  List<Object> get props => [recipeName, imageName];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:recipe_hinge/bloc/user_liked_recipes/user_liked_recipe_bloc.dart';
import 'package:recipe_hinge/infrastructure/overall/repositories/storage_service.dart';
import 'package:recipe_hinge/models/recipe_card.dart';
import 'package:recipe_hinge/presentation/util/widgets/recipe_scroll_view.dart';

class UserLikedRecipeWidget extends StatefulWidget {
  final List<RecipeCard> recipeCards;
  UserLikedRecipeWidget({Key key, List<RecipeCard> recipes})
      : assert(recipes != null),
        recipeCards = recipes,
        super(key: key);

  @override
  _UserLikedRecipeWidgetState createState() => _UserLikedRecipeWidgetState();
}

class _UserLikedRecipeWidgetState extends State<UserLikedRecipeWidget> {
  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService();
    final Size size = MediaQuery.of(context).size;
    return Expanded(
        child: ListView.builder(
      itemCount: widget.recipeCards.length,
      itemBuilder: (context, index) {
        final RecipeCard recipe = widget.recipeCards[index];
        return FutureBuilder(
          future: storage.imageURL(recipe.imageName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              NetworkImage foodImage = NetworkImage(snapshot.data);

              return Slidable(
                  actionExtentRatio: 0.25,
                  actionPane: SlidableDrawerActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Remove',
                      color: Colors.white,
                      iconWidget: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onTap: () {
                        BlocProvider.of<UserLikedRecipeBloc>(context)
                            .add(RemoveUserRecipe(cardToRemove: recipe));
                        widget.recipeCards.removeAt(index);
                        setState(() {});
                      },
                    ),
                  ],
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeScrollView(
                                recipe: recipe,
                                foodImage: foodImage,
                              ),
                            ));
                      },
                      child: Container(
                          width: size.width,
                          height: size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: foodImage, fit: BoxFit.cover)),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, spreadRadius: 0.5)
                                ],
                                gradient: LinearGradient(
                                    colors: [Colors.black12, Colors.black87],
                                    begin: Alignment.topCenter,
                                    stops: [0.3, 1],
                                    end: Alignment.bottomCenter)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  recipe.recipeName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  recipe.recipeTags.toString(),
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          )),
                    ),
                  ));
            } else {
              return Container();
            }
          },
        );
      },
    ));
  }
}

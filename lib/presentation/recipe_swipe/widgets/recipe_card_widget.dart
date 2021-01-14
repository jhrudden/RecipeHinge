import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_swipe/directional_tag/directional_tag_bloc.dart';
import '../../../infrastructure/overall/repositories/storage_service.dart';
import '../../../models/recipe_card.dart';
import '../../util/widgets/recipe_scroll_view.dart';
import 'blank_recipe_card.dart';

class RecipeCardWidget extends StatefulWidget {
  final RecipeCard recipeCard;
  RecipeCardWidget({Key key, this.recipeCard}) : super(key: key);

  @override
  _RecipeCardWidgetState createState() => _RecipeCardWidgetState();
}

class _RecipeCardWidgetState extends State<RecipeCardWidget> {
  @override
  Widget build(BuildContext context) {
    final StorageService _storage = StorageService();
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(top: 30),
        child: FutureBuilder(
          future: _storage.imageURL(widget.recipeCard.imageName),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              NetworkImage foodImage = NetworkImage(snapshot.data);
              return GestureDetector(
                child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    child: Container(
                      height: size.height * 0.7,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: foodImage,
                            fit: BoxFit.cover,
                          )),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12, spreadRadius: 0.5)
                              ],
                              gradient: LinearGradient(
                                  colors: [Colors.black12, Colors.black38],
                                  begin: Alignment.center,
                                  stops: [0.4, 1],
                                  end: Alignment.bottomCenter)),
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 10,
                                  left: 10,
                                  bottom: 10,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildRecipeInfo(),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 16, right: 8),
                                          child: Icon(Icons.info,
                                              color: Colors.white)),
                                    ],
                                  )),
                              buildSwipeTag(context),
                            ],
                          )),
                    )),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeScrollView(
                        recipe: widget.recipeCard,
                        foodImage: foodImage,
                      ),
                    )),
              );
            } else {
              return BlankRecipeCard();
            }
          },
        ));
  }

  Widget buildRecipeInfo() => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.recipeCard.recipeName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              widget.recipeCard.recipeTags.toString(),
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );

  buildSwipeTag(BuildContext context) {
    return BlocBuilder<DirectionalTagBloc, DirectionalTagState>(
      builder: (context, state) {
        if (state is NoDirection) {
          return buildSwipeSpecifics('none');
        } else if (state is Right) {
          return buildSwipeSpecifics('right');
        } else if (state is Left) {
          return buildSwipeSpecifics('left');
        } else {
          return Container();
        }
      },
    );
  }

  buildSwipeSpecifics(String direction) {
    final color = direction == 'right' ? Colors.green : Colors.pink;
    final angle = direction == 'right' ? -0.5 : 0.5;

    if (direction == 'left' || direction == 'right') {
      return Positioned(
        top: 20,
        right: direction == 'right' ? null : 20,
        left: direction == 'right' ? 20 : null,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              direction == 'right' ? 'LIKE' : 'PASS',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

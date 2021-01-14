import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../models/recipe_card.dart';

class RecipeScrollView extends StatelessWidget {
  final RecipeCard _recipe;
  final NetworkImage _foodImage;
  const RecipeScrollView({Key key, RecipeCard recipe, NetworkImage foodImage})
      : assert(recipe != null),
        assert(foodImage != null),
        _foodImage = foodImage,
        _recipe = recipe,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Material(
                elevation: 5,
                child: Container(
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: _foodImage,
                    fit: BoxFit.cover,
                  )),
                )),
            Center(
                child: Padding(
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              child: Text(
                _recipe.recipeName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                'Tags: ' + _recipe.recipeTags.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(
                _recipe.recipeDescription,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ),
          ]),
        ));
  }
}

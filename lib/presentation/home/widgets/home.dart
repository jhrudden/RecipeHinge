import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../../auth/infrastructure/authentication_service.dart';
import '../../../infrastructure/overall/repositories/database.dart';
import '../../../models/dashboard_item.dart';
import '../../quiz/widgets/quiz.dart';
import '../../recipe_swipe/widgets/recipe_swipe.dart';
import '../../user_recipe_view/widgets/user_recipe_page.dart';

class Home extends StatelessWidget {
  final DashBoardItem quiz = DashBoardItem(
      icon: Icon(
        LineIcons.question_circle,
        size: 70,
        color: Colors.green[200],
      ),
      title: 'Find Interests',
      subText: 'Questionaire Used To Find Recipes You\'ll Love!',
      onTap: (context, data) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Provider.value(
                    value: data,
                    child: Quiz(),
                  )),
        );
      });

  final DashBoardItem processRecipes = DashBoardItem(
      icon: Icon(
        LineIcons.filter,
        size: 70,
        color: Colors.orange[200],
      ),
      title: 'Filter Recipes',
      subText: 'Swipe Through Recipes Generated Based on Your Interests',
      onTap: (context, data) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Provider.value(
                    value: data,
                    child: RecipeSwipe(),
                  )),
        );
      });

  final DashBoardItem userRecipeScreen = DashBoardItem(
      icon: Icon(
        LineIcons.heart,
        size: 70,
        color: Colors.red[200],
      ),
      title: 'Process Favorites',
      subText: 'Preview & Filter The Recipes \nYou Liked',
      onTap: (context, data) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Provider.value(
                    value: data,
                    child: UserRecipePage(),
                  )),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueGrey[300],
          actions: [
            IconButton(
              onPressed: () async {
                await AuthenticationService().signOut();
              },
              icon: Icon(Icons.exit_to_app, color: Colors.white, size: 35.0),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.blueGrey[300],
                ),
                height: MediaQuery.of(context).size.height * 0.25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTop(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                buildPagelinks(context),
              ],
            )
          ],
        ));
  }

  Widget buildTop(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are You Hungry? \nSelect An Option',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text('  Dashboard',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold))
          ],
        ));
  }

  Widget buildPagelinks(BuildContext context) {
    final DatabaseService data = Provider.of<DatabaseService>(context);
    final Size size = MediaQuery.of(context).size;
    List<DashBoardItem> items = [quiz, processRecipes, userRecipeScreen];
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: items.map((item) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => item.onTap(context, data),
                      child: Material(
                        borderRadius: BorderRadius.circular(15),
                        elevation: 5,
                        child: Container(
                          width: size.width - 32,
                          height: size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Colors.white70, Colors.grey[200]],
                              stops: [0.4, 1],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              item.icon,
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(item.subText,
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 15,
                                      )),
                                ],
                              )),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            )));
  }
}

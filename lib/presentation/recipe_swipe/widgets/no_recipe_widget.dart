import 'package:flutter/material.dart';

class NoRecipeWidget extends StatelessWidget {
  const NoRecipeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.25),
        child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.clear,
                    size: 60,
                    color: Colors.grey,
                  ),
                  Text(
                    'No More Recipes',
                    style: TextStyle(fontSize: 28, color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )));
  }
}

import 'package:flutter/material.dart';

class BlankRecipeCard extends StatelessWidget {
  const BlankRecipeCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height * 0.7,
        width: size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black12, spreadRadius: 0.5)
                ],
                gradient: LinearGradient(
                    colors: [Colors.black12, Colors.black87],
                    begin: Alignment.center,
                    stops: [0.4, 1],
                    end: Alignment.bottomCenter)),
            child: Container()));
  }
}

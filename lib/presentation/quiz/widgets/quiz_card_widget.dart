import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_hinge/presentation/util/models/quiz_card_combo.dart';

import '../../../bloc/quiz/quiz_bloc.dart';

class QuizCardWidget extends StatelessWidget {
  final QuizCardCombo combo;

  const QuizCardWidget({Key key, @required QuizCardCombo combo})
      : assert(combo != null),
        combo = combo,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.white70, Colors.grey[200]]),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[200]),
              value: combo.percentDone,
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  combo.card.question,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Column(
              children: combo.card.answers
                  .map(
                    (answer) => Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<QuizBloc>(context)
                                .add(SaveTag(tag: answer));
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 1.2,
                                ),
                                borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  answer.toLowerCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  textAlign: TextAlign.start,
                                )),
                          ),
                        )),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

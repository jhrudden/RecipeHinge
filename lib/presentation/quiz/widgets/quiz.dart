import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../bloc/quiz/quiz_bloc.dart';
import '../../../infrastructure/overall/repositories/database.dart';
import '../../util/widgets/loading_page.dart';
import 'quiz_card_widget.dart';
import 'tag_card.dart';

class Quiz extends StatelessWidget {
  const Quiz({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Find Interests',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green[200],
          elevation: 0,
        ),
        body: SafeArea(
            child: Stack(alignment: Alignment.topCenter, children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.green[200],
              ),
              height: MediaQuery.of(context).size.height * 0.25),
          Column(children: <Widget>[
            _buildBody(context),
          ])
        ])));
  }

  Widget _buildBody(BuildContext context) {
    final DatabaseService data = Provider.of<DatabaseService>(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: BlocProvider(
            create: (_) => QuizBloc(repository: data),
            child: BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
              if (state is QuizInitial) {
                BlocProvider.of<QuizBloc>(context).add(BuildQuiz());
                return Container();
              } else if (state is Loading)
                return LoadingPage();
              else if (state is RetrievedCard) {
                if (state.combo.card != null) {
                  return QuizCardWidget(combo: state.combo);
                } else {
                  BlocProvider.of<QuizBloc>(context).add(GetTags());
                  return Container();
                }
              } else if (state is LoadedTags) {
                return TagCard(tags: state.tags);
              } else
                return Container();
            })),
      ),
    );
  }
}

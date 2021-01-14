import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../bloc/recipe_swipe/directional_tag/directional_tag_bloc.dart';
import '../../../bloc/recipe_swipe/recipe_swipe_bloc.dart';
import '../../../infrastructure/overall/repositories/database.dart';
import '../../util/widgets/loading_page.dart';
import 'no_recipe_widget.dart';
import 'swipeable_recipe_card.dart';

class RecipeSwipe extends StatelessWidget {
  const RecipeSwipe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Recipes'),
        backgroundColor: Colors.orange[200],
        elevation: 0,
      ),
      body: SafeArea(
          child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.orange[200],
              ),
              height: MediaQuery.of(context).size.height * 0.25),
          _buildBody(context),
        ],
      )),
    );
  }

  Widget _buildBody(BuildContext context) {
    final DatabaseService data = Provider.of<DatabaseService>(context);

    return BlocProvider(
      create: (_) => RecipeSwipeBloc(repository: data),
      child: BlocBuilder<RecipeSwipeBloc, RecipeSwipeState>(
        builder: (context, state) {
          if (state is EmptyDeck) {
            BlocProvider.of<RecipeSwipeBloc>(context).add(GetRecipeDeck());
            return Container();
          } else if (state is LoadingDeck) {
            return LoadingPage();
          } else if (state is LoadedCard) {
            return (state.card != null)
                ? BlocProvider(
                    create: (_) => DirectionalTagBloc(),
                    child: SwipeableRecipeCard(recipe: state.card),
                  )
                : NoRecipeWidget();
          } else
            return Container();
        },
      ),
    );
  }
}

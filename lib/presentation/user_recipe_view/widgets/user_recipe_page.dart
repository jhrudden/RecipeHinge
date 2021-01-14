import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recipe_hinge/bloc/user_liked_recipes/user_liked_recipe_bloc.dart';
import 'package:recipe_hinge/infrastructure/overall/repositories/database.dart';

import 'package:recipe_hinge/presentation/user_recipe_view/widgets/user_liked_recipe_widget.dart';
import 'package:recipe_hinge/presentation/util/widgets/loading_page.dart';

class UserRecipePage extends StatelessWidget {
  const UserRecipePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Process Favorites'),
        backgroundColor: Colors.red[200],
        elevation: 0,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.red[200],
              ),
              height: MediaQuery.of(context).size.height * 0.25),
          buildBlocWidgets(context),
        ],
      )),
    );
  }

  Widget buildBlocWidgets(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            UserLikedRecipeBloc(data: Provider.of<DatabaseService>(context)),
        child: BlocBuilder<UserLikedRecipeBloc, UserLikedRecipeState>(
          builder: (context, state) {
            if (state is Initial) {
              BlocProvider.of<UserLikedRecipeBloc>(context)
                  .add(GetUsersLikedRecipes());
              return Container();
            } else if (state is LoadingRecipes) {
              return LoadingPage();
            } else if (state is LoadedRecipes) {
              return BlocProvider.value(
                value: BlocProvider.of<UserLikedRecipeBloc>(context),
                child: UserLikedRecipeWidget(
                  recipes: state.likedRecipes,
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}

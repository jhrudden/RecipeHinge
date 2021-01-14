import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_swipe/directional_tag/directional_tag_bloc.dart';
import '../../../bloc/recipe_swipe/recipe_swipe_bloc.dart';
import '../../../models/recipe_card.dart';
import 'recipe_card_widget.dart';

class SwipeableRecipeCard extends StatelessWidget {
  final RecipeCard recipeCard;

  const SwipeableRecipeCard({Key key, RecipeCard recipe})
      : assert(recipe != null),
        recipeCard = recipe,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (pointerEvent) {
        BlocProvider.of<DirectionalTagBloc>(context, listen: false)
            .add(UpdatePosition(pointerEvent.localDelta.dx));
      },
      onPointerCancel: (_) {
        BlocProvider.of<DirectionalTagBloc>(context, listen: false)
            .add(ResetPosition());
      },
      onPointerUp: (_) {
        BlocProvider.of<DirectionalTagBloc>(context, listen: false)
            .add(ResetPosition());
      },
      child: Draggable(
        child: BlocProvider.value(
          value: BlocProvider.of<DirectionalTagBloc>(context, listen: false),
          child: RecipeCardWidget(
            recipeCard: recipeCard,
          ),
        ),
        feedback: Material(
          type: MaterialType.transparency,
          child: BlocProvider.value(
            value: BlocProvider.of<DirectionalTagBloc>(context, listen: false),
            child: RecipeCardWidget(
              recipeCard: recipeCard,
            ),
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) => onDragEnd(details, context),
      ),
    );
  }

  onDragEnd(DraggableDetails details, BuildContext context) {
    final minimumDrag = 100;
    if (details.offset.dx > minimumDrag) {
      BlocProvider.of<RecipeSwipeBloc>(context).add(SaveRecipe());
    } else if (details.offset.dx < -minimumDrag) {
      BlocProvider.of<RecipeSwipeBloc>(context).add(PassRecipe());
    }
  }
}

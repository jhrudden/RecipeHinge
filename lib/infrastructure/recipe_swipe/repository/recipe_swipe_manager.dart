import '../../../models/recipe_card.dart';
import '../../overall/repositories/recipe_data_service.dart';
import '../../overall/repositories/user_data_service.dart';

class RecipeSwipeManager {
  final UserDataService _userDataService;
  final RecipeDataService _recipeDataService;
  final List<RecipeCard> _recipeDeck = [];

  RecipeSwipeManager({UserDataService userData, RecipeDataService recipeData})
      : assert(userData != null),
        assert(recipeData != null),
        _userDataService = userData,
        _recipeDataService = recipeData;

  Future<void> buildRecipeDeck() async {
    List<String> userTags = await _userDataService.userTags;
    List<RecipeCard> allRecipes = await _recipeDataService.allRecipeCards;
    List<RecipeCard> userRecipes = await _userDataService.likedRecipes;
    List<RecipeCard> recipesToProcess = await _userDataService.recipesToProcess;
    List<RecipeCard> processedRecipes = await _userDataService.processedRecipes;
    List<String> tagsUsedToPropogateRecipeList = [];
    Set<RecipeCard> toProcess = Set();
    toProcess.addAll(recipesToProcess);

    List<RecipeCard> filteredRecipes = allRecipes
        .where((element) {
          List<String> tagsUsed = [];
          int count = 0;
          if (!processedRecipes.contains(element)) {
            for (String tag in element.recipeTags) {
              if (userTags.contains(tag)) {
                count += 1;
                tagsUsed.add(tag);
              }
            }
            if (count > 1) {
              tagsUsedToPropogateRecipeList.addAll(tagsUsed);
              return true;
            }
            return false;
          } else {
            return false;
          }
        })
        .where((element) => !userRecipes.contains(element))
        .toList();
    toProcess.addAll(filteredRecipes);
    _recipeDeck.addAll(toProcess);
    await this.saveRecipesToProcess();
  }

  RecipeCard getFirst() {
    if (_recipeDeck.length != 0) {
      return _recipeDeck[_recipeDeck.length - 1];
    } else
      return null;
  }

  Future<RecipeCard> popRecipe() async {
    if (_recipeDeck.isNotEmpty) {
      RecipeCard result = _recipeDeck.removeAt(_recipeDeck.length - 1);
      await saveRecipesToProcess();
      return result;
    }
    return null;
  }

  Future<void> saveRecipe(RecipeCard recipe) async {
    _userDataService.likeRecipe(recipe);
  }

  Future<void> saveRecipesToProcess() async {
    await _userDataService.updateRecipesToProcess(_recipeDeck);
  }

  Future<void> saveProcessedRecipe(RecipeCard recipe) async {
    await _userDataService.saveProcessedRecipe(recipe);
  }
}

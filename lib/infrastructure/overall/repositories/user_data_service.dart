import '../../../models/quiz_card.dart';
import '../../../models/recipe_card.dart';
import 'database.dart';

/// Object that handles interacting with DataBase for any actions that a
/// costumer may need to do that pertains with their own user data.

class UserDataService {
  final DatabaseService _dataBase;
  final String _uid;

  UserDataService._(this._dataBase, this._uid);

  factory UserDataService.build(DatabaseService data, String uid) {
    assert(data != null);
    return UserDataService._(data, uid);
  }

  // gets a map of all user data
  Future<Map<String, dynamic>> get userData async {
    return await _dataBase.profileCollection.doc(_uid).get().then((value) {
      return value.data();
    });
  }

  // gets the users current tags.
  Future<List<String>> get userTags async {
    return await this.userData.then((value) {
      List<dynamic> userTags = value['tags'];
      return userTags.cast<String>();
    });
  }

  /// gets the user's current recipes in process.
  Future<List<RecipeCard>> get likedRecipes async {
    return await this.getAbstractRecipe('likedRecipes');
  }

  /// gets the user's current recipes in process.
  Future<List<RecipeCard>> get recipesToProcess async {
    return await this.getAbstractRecipe('recipesToProcess');
  }

  /// gets the user's current recipes that have been process.
  Future<List<RecipeCard>> get processedRecipes async {
    return await this.getAbstractRecipe('processedRecipes');
  }

  // Retrieve and process recipes from database at given tag
  Future<List<RecipeCard>> getAbstractRecipe(String dataBaseTag) async {
    List<RecipeCard> result = [];
    List<dynamic> recipeRefs =
        await userData.then((value) => value[dataBaseTag]);
    for (Map<String, dynamic> ref in recipeRefs) {
      result.add(RecipeCard.fromMap(ref));
    }
    return result;
  }

  /// gets the user's current processed Questions.
  Future<List<QuizCard>> get userProcessQuestions async {
    List<QuizCard> userQuestions = [];
    List<dynamic> questionRefs =
        await userData.then((value) => value['processedQuestions']);
    for (Map<String, dynamic> ref in questionRefs) {
      userQuestions.add(QuizCard.fromMap(ref));
    }
    return userQuestions;
  }

  // initializes a user profile. (should only be called when first registering)
  Future buildUser(String displayName) async {
    return await _dataBase.profileCollection.doc(_uid).set({
      'tags': [],
      'displayName': displayName,
      'recipesToProcess': [],
      'processedQuestions': [],
      'likedRecipes': [],
      'processedRecipes': [],
    });
  }

  /// adds the given tags to user's list of tags
  Future updateUserTags(List<String> tags) async {
    return await _dataBase.profileCollection.doc(_uid).update({
      'tags': tags,
    });
  }

  /// adds given list of tags to users list of tags
  Future<void> addUserTags(List<String> tags) async {
    Set<String> allTags = Set.of(tags);
    List<dynamic> userTags = await userData.then((data) => data['tags']);

    for (dynamic tag in userTags) {
      allTags.add(tag as String);
    }
    await updateUserTags(allTags.toList());
  }

  /// adds given recipes to a players likedRecipeList
  Future<void> likeRecipe(RecipeCard recipe) async {
    List<RecipeCard> userRecipes = await this.likedRecipes;
    Set<RecipeCard> noDuplicates = Set.of(userRecipes);
    noDuplicates.add(recipe);
    await updateUserRecipes(noDuplicates.toList());
  }

  /// adds the given tags to user's list of tags
  Future updateUserRecipes(List<RecipeCard> recipes) async {
    this.updateAbstractRecipes(recipes, 'likedRecipes');
  }

  /// set user's processed recipes
  Future updateRecipesToProcess(List<RecipeCard> recipes) async {
    this.updateAbstractRecipes(recipes, 'recipesToProcess');
  }

  /// set user's processed recipes
  Future updateProcessedRecipes(List<RecipeCard> recipes) async {
    this.updateAbstractRecipes(recipes, 'processedRecipes');
  }

  Future updateAbstractRecipes(
      List<RecipeCard> recipes, String tagToUpdate) async {
    List<Map<String, dynamic>> updatedAsMaps =
        recipes.map((recipe) => recipe.toMap()).toList();
    await _dataBase.profileCollection.doc(_uid).update({
      tagToUpdate: updatedAsMaps,
    });
  }

  Future saveProcessedRecipe(RecipeCard toBeProcessed) async {
    List<RecipeCard> userProcessedRecipes = await this.processedRecipes;
    Set<RecipeCard> noDuplicates = Set.of(userProcessedRecipes);
    noDuplicates.add(toBeProcessed);
    await updateProcessedRecipes(noDuplicates.toList());
  }

  Future saveProcessedQuestions(List<QuizCard> processedQuestions) async {
    List<QuizCard> userQuestion = await this.userProcessQuestions;
    Set<QuizCard> noDuplicates = Set.of(userQuestion);
    noDuplicates.addAll(processedQuestions);
    await updateProcessedQuestions(noDuplicates.toList());
  }

  /// adds the given processRecipes to user's list of tags
  Future updateProcessedQuestions(List<QuizCard> questions) async {
    List<Map<String, dynamic>> updateQuizCards =
        questions.map((question) => question.toMap()).toList();
    return await _dataBase.profileCollection.doc(_uid).update({
      'processedQuestions': updateQuizCards,
    });
  }
}

import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe_search_result.dart';

abstract interface class RecipeRemoteDataSource {
  Future<RecipeSearchResult> findRecipes(List<Ingredient> ingredients);
}

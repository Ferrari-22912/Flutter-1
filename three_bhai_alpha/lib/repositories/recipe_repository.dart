import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe_search_result.dart';

abstract interface class RecipeRepository {
  /// Throws a [Failure] on network or server errors.
  Future<RecipeSearchResult> findRecipes(List<Ingredient> ingredients);
}

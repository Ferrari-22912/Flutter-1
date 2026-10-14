import 'package:three_bhai/models/recipe.dart';

class RecipeSearchResult {
  const RecipeSearchResult({required this.recipes, required this.sourceName});

  final List<Recipe> recipes;
  final String sourceName;
}

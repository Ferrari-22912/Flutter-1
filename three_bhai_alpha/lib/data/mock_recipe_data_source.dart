import 'package:three_bhai/data/mock_recipes.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe.dart';
import 'package:three_bhai/models/recipe_search_result.dart';
import 'recipe_remote_data_source.dart';

/// ALPHA: ranks the built-in sample recipes against the chosen ingredients.
/// No network. Works offline.
class MockRecipeDataSource implements RecipeRemoteDataSource {
  static const sourceName = '3Bhai sample kitchen';

  @override
  Future<RecipeSearchResult> findRecipes(List<Ingredient> ingredients) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (ingredients.isEmpty) {
      return const RecipeSearchResult(recipes: [], sourceName: sourceName);
    }
    final have = {for (final i in ingredients) i.name.toLowerCase()};

    final ranked = <Recipe>[];
    for (final r in mockRecipes) {
      final names = r.ingredients.map((i) => i.name).toList();
      final matched = names.where((n) => have.contains(n.toLowerCase())).length;
      if (matched == 0) continue;
      ranked.add(
        r.copyWith(
          matchedCount: matched,
          missingIngredients:
              names.where((n) => !have.contains(n.toLowerCase())).toList(),
        ),
      );
    }
    ranked.sort((a, b) {
      final byMatch = b.matchedCount.compareTo(a.matchedCount);
      return byMatch != 0
          ? byMatch
          : a.missingIngredients.length.compareTo(b.missingIngredients.length);
    });
    return RecipeSearchResult(
      recipes: ranked.take(10).toList(),
      sourceName: sourceName,
    );
  }
}

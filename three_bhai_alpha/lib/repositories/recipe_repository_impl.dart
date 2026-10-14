import 'package:three_bhai/data/recipe_remote_data_source.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe_search_result.dart';
import 'package:three_bhai/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  const RecipeRepositoryImpl(this._remote);

  final RecipeRemoteDataSource _remote;

  @override
  Future<RecipeSearchResult> findRecipes(List<Ingredient> ingredients) =>
      _remote.findRecipes(ingredients);
}

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/controllers/recipe_results_controller.dart';
import 'package:three_bhai/data/mock_recipe_data_source.dart';
import 'package:three_bhai/data/mock_recipes.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe_search_result.dart';
import 'package:three_bhai/repositories/mock_auth_repository.dart';
import 'package:three_bhai/repositories/mock_history_repository.dart';
import 'package:three_bhai/repositories/recipe_repository.dart';
import 'package:three_bhai/repositories/recipe_repository_impl.dart';

const rice = Ingredient(
  id: 'rice',
  name: 'Rice',
  emoji: '🍚',
  category: IngredientCategory.grains,
);

class _DelayedRecipes implements RecipeRepository {
  final requests = <Completer<RecipeSearchResult>>[];

  @override
  Future<RecipeSearchResult> findRecipes(List<Ingredient> ingredients) {
    final pending = Completer<RecipeSearchResult>();
    requests.add(pending);
    return pending.future;
  }
}

void main() {
  test('search saves results and saved searches open without another save',
      () async {
    final history = MockHistoryRepository(MockAuthRepository());
    final controller = RecipeResultsController(
      RecipeRepositoryImpl(MockRecipeDataSource()),
      history,
    );
    addTearDown(controller.onDelete);
    final before = await history.getHistory();
    await controller.search(const [rice]);
    expect(controller.state.status, RecipeSearchStatus.loaded);
    expect(controller.state.recipes, isNotEmpty);
    final after = await history.getHistory();
    expect(after.length, before.length + 1);
    expect(after.first.ingredients, ['Rice']);
    controller.showSaved(after.first);
    expect(controller.state.recipes, same(after.first.recipes));
    expect((await history.getHistory()).length, after.length);
  });

  test('an older response cannot replace or save newer results', () async {
    final recipes = _DelayedRecipes();
    final history = MockHistoryRepository(MockAuthRepository());
    final controller = RecipeResultsController(recipes, history);
    addTearDown(controller.onDelete);
    final first = controller.search(const [rice]);
    final second = controller.search(const [rice]);
    recipes.requests[1].complete(RecipeSearchResult(
      recipes: [mockRecipes[1]],
      sourceName: 'new',
    ));
    await second;
    recipes.requests[0].complete(RecipeSearchResult(
      recipes: [mockRecipes[0]],
      sourceName: 'old',
    ));
    await first;
    expect(controller.state.sourceName, 'new');
    final records = await history.getHistory();
    expect(records.where((r) => r.sourceName == 'old'), isEmpty);
  });

  test('leaving the page during a search does not update or save', () async {
    final recipes = _DelayedRecipes();
    final history = MockHistoryRepository(MockAuthRepository());
    final controller = RecipeResultsController(recipes, history);
    final request = controller.search(const [rice]);
    controller.onDelete();
    recipes.requests.single.complete(RecipeSearchResult(
      recipes: [mockRecipes[0]],
      sourceName: 'closed',
    ));
    await request;
    expect(controller.state.status, RecipeSearchStatus.loading);
    expect((await history.getHistory()).where((r) => r.sourceName == 'closed'),
        isEmpty);
  });
}

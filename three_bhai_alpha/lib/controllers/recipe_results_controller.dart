import 'package:get/get.dart';
import 'package:three_bhai/repositories/recipe_repository.dart';
import 'package:three_bhai/repositories/history_repository.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/models/recipe.dart';
import 'package:three_bhai/models/search_record.dart';

enum RecipeSearchStatus { loading, loaded, failure }

class RecipeResultsState {
  const RecipeResultsState({
    this.status = RecipeSearchStatus.loading,
    this.recipes = const [],
    this.sourceName = '',
    this.errorMessage,
  });

  final RecipeSearchStatus status;
  final List<Recipe> recipes;
  final String sourceName;
  final String? errorMessage;
}

class RecipeResultsController extends GetxController {
  // Lecture 2: Rx owns state; Obx reads it and rebuilds the UI.
  final observable = const RecipeResultsState().obs;
  RecipeResultsState get state => observable.value;

  void _updateState(RecipeResultsState next) {
    // Lecture 2 lifecycle: never notify a screen after its route is disposed.
    if (!isClosed) observable.value = next;
  }

  RecipeResultsController(this._recipes, this._history);

  final RecipeRepository _recipes;
  final HistoryRepository _history;
  List<Ingredient> _last = const [];
  int _requestId = 0;

  Future<void> search(List<Ingredient> ingredients) async {
    _last = ingredients;
    final id = ++_requestId;
    _updateState(const RecipeResultsState());
    try {
      final result = await _recipes.findRecipes(ingredients);
      if (id != _requestId || isClosed) return;
      if (result.recipes.isNotEmpty) {
        try {
          await _history.save(
            ingredients: ingredients.map((i) => i.name).toList(),
            sourceName: result.sourceName,
            recipes: result.recipes,
          );
        } catch (_) {
          // A failed history save must not hide successful recipe results.
        }
      }
      if (id != _requestId || isClosed) return;
      _updateState(
        RecipeResultsState(
          status: RecipeSearchStatus.loaded,
          recipes: result.recipes,
          sourceName: result.sourceName,
        ),
      );
    } on Failure catch (e) {
      if (id != _requestId || isClosed) return;
      _updateState(
        RecipeResultsState(
          status: RecipeSearchStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      if (id != _requestId || isClosed) return;
      _updateState(
        const RecipeResultsState(
          status: RecipeSearchStatus.failure,
          errorMessage: 'Something went wrong while finding recipes.',
        ),
      );
    }
  }

  Future<void> retry() => search(_last);

  /// Shows a saved history entry without calling any API.
  void showSaved(SearchRecord record) {
    _requestId++;
    _updateState(
      RecipeResultsState(
        status: RecipeSearchStatus.loaded,
        recipes: record.recipes,
        sourceName: record.sourceName,
      ),
    );
  }
}

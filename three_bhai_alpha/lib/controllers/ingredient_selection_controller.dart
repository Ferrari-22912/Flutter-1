import 'package:get/get.dart';
import 'package:three_bhai/repositories/ingredient_repository.dart';
import 'package:three_bhai/core/error/failures.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/controllers/ingredient_selection_state.dart';

class IngredientSelectionController extends GetxController {
  // Lecture 2: Rx owns state; Obx reads it and rebuilds the UI.
  final observable = const IngredientSelectionState().obs;
  IngredientSelectionState get state => observable.value;

  void _updateState(IngredientSelectionState next) {
    // Lecture 2 lifecycle: never notify a screen after its route is disposed.
    if (!isClosed) observable.value = next;
  }

  IngredientSelectionController(this._repository);

  final IngredientRepository _repository;

  Future<void> load() async {
    _updateState(state.copyWith(status: IngredientStatus.loading));
    try {
      final items = await _repository.getIngredients();
      _updateState(state.copyWith(status: IngredientStatus.loaded, all: items));
    } on Failure catch (e) {
      _updateState(
        state.copyWith(
          status: IngredientStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      _updateState(
        state.copyWith(
          status: IngredientStatus.failure,
          errorMessage: 'Could not load ingredients. Try again.',
        ),
      );
    }
  }

  void selectCategory(IngredientCategory? category) {
    if (category == state.category) return;
    _updateState(state.copyWith(category: () => category, expanded: false));
  }

  void setQuery(String query) {
    if (query == state.query) return;
    _updateState(state.copyWith(query: query, expanded: false));
  }

  void toggle(String id) {
    final next = {...state.selectedIds};
    if (!next.remove(id)) next.add(id);
    _updateState(state.copyWith(selectedIds: next));
  }

  void toggleExpanded() =>
      _updateState(state.copyWith(expanded: !state.expanded));

  void clearSelection() => _updateState(state.copyWith(selectedIds: const {}));
}

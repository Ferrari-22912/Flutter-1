import 'package:flutter_test/flutter_test.dart';
import 'package:three_bhai/models/ingredient.dart';
import 'package:three_bhai/repositories/ingredient_repository.dart';
import 'package:three_bhai/controllers/ingredient_selection_controller.dart';
import 'package:three_bhai/controllers/ingredient_selection_state.dart';

class _FakeRepo implements IngredientRepository {
  @override
  Future<List<Ingredient>> getIngredients() async => const [
        Ingredient(
          id: 'apple',
          name: 'Apple',
          emoji: '🍎',
          category: IngredientCategory.fruits,
        ),
        Ingredient(
          id: 'rice',
          name: 'Rice',
          emoji: '🍚',
          category: IngredientCategory.grains,
        ),
      ];
}

void main() {
  late IngredientSelectionController controller;

  setUp(() async {
    controller = IngredientSelectionController(_FakeRepo());
    await controller.load();
  });

  tearDown(() => controller.onDelete());

  test('loads ingredients', () {
    expect(controller.state.status, IngredientStatus.loaded);
    expect(controller.state.all.length, 2);
  });

  test('filters by category and resets with All', () {
    controller.selectCategory(IngredientCategory.grains);
    expect(controller.state.visible.map((i) => i.id), ['rice']);
    controller.selectCategory(null);
    expect(controller.state.visible.length, 2);
  });

  test('multi-select toggles and enables generate', () {
    expect(controller.state.canGenerate, isFalse);
    controller.toggle('apple');
    controller.toggle('rice');
    expect(controller.state.selectedCount, 2);
    expect(controller.state.canGenerate, isTrue);
    controller.toggle('apple');
    expect(controller.state.selectedCount, 1);
    controller.clearSelection();
    expect(controller.state.canGenerate, isFalse);
  });

  test('search narrows the list and ignores the collapse limit', () {
    controller.setQuery('app');
    expect(controller.state.visible.map((i) => i.id), ['apple']);
    controller.setQuery('');
    expect(controller.state.visible.length, 2);
  });
}

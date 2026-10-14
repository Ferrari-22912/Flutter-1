import 'package:three_bhai/repositories/auth_repository.dart';
import 'package:three_bhai/data/mock_recipes.dart';
import 'package:three_bhai/models/recipe.dart';
import 'package:three_bhai/models/search_record.dart';
import 'package:three_bhai/repositories/history_repository.dart';

/// ALPHA: in-memory search history, pre-filled with sample searches so the
/// History screen is not empty. Kept per user id for the life of the app.
class MockHistoryRepository implements HistoryRepository {
  MockHistoryRepository(this._auth);

  final AuthRepository _auth;
  static const _source = '3Bhai sample kitchen';
  final Map<String, List<SearchRecord>> _store = {};

  String get _uid => _auth.currentUser?.id ?? 'signed_out';

  List<SearchRecord> get _mine => _store.putIfAbsent(_uid, _seed);

  List<SearchRecord> _seed() {
    final now = DateTime.now();
    Recipe pick(String id, int matched, List<String> missing) => mockRecipes
        .firstWhere((r) => r.id == id)
        .copyWith(matchedCount: matched, missingIngredients: missing);

    return [
      SearchRecord(
        id: 'seed-1',
        ingredients: const ['Chicken', 'Rice', 'Onion', 'Tomato'],
        sourceName: _source,
        createdAt: now.subtract(const Duration(hours: 3)),
        recipes: [
          pick('m1', 4, const ['Yogurt', 'Garam masala', 'Ghee', 'Salt']),
          pick('m8', 2, const [
            'Ginger',
            'Garlic',
            'Chili',
            'Black pepper',
            'Garam masala',
            'Coriander',
            'Cooking oil',
          ]),
        ],
      ),
      SearchRecord(
        id: 'seed-2',
        ingredients: const ['Eggs', 'Onion', 'Tomato'],
        sourceName: _source,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        recipes: [
          pick('m5', 3, const ['Chili', 'Coriander', 'Butter', 'Salt']),
          pick('m2', 1, const [
            'Rice',
            'Garlic',
            'Carrot',
            'Green peas',
            'Soy sauce',
            'Cooking oil',
            'Black pepper',
          ]),
        ],
      ),
      SearchRecord(
        id: 'seed-3',
        ingredients: const ['Pasta', 'Tomato', 'Garlic', 'Cheese'],
        sourceName: _source,
        createdAt: now.subtract(const Duration(days: 3)),
        recipes: [
          pick('m3', 4, const [
            'Tomato paste',
            'Onion',
            'Cream',
            'Basil',
            'Olive oil',
          ]),
        ],
      ),
      SearchRecord(
        id: 'seed-4',
        ingredients: const ['Potato', 'Onion', 'Ginger'],
        sourceName: _source,
        createdAt: now.subtract(const Duration(days: 6)),
        recipes: [
          pick('m4', 3, const [
            'Tomato',
            'Garlic',
            'Cumin',
            'Turmeric',
            'Chili',
            'Coriander',
            'Cooking oil',
          ]),
        ],
      ),
    ];
  }

  @override
  Future<List<SearchRecord>> getHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List.of(_mine);
  }

  @override
  Future<void> save({
    required List<String> ingredients,
    required String sourceName,
    required List<Recipe> recipes,
  }) async {
    _mine.insert(
      0,
      SearchRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        ingredients: ingredients,
        sourceName: sourceName,
        recipes: recipes,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> delete(String id) async => _mine.removeWhere((r) => r.id == id);

  @override
  Future<void> clear() async => _mine.clear();
}

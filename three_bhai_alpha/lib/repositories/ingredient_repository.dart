import 'package:three_bhai/models/ingredient.dart';

abstract interface class IngredientRepository {
  Future<List<Ingredient>> getIngredients();
}

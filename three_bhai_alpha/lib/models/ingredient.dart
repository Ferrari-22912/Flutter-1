enum IngredientCategory {
  fruits('Fruits', '🍎'),
  vegetables('Vegetables', '🥦'),
  grains('Grains', '🌾'),
  proteins('Proteins', '🍗'),
  seafood('Seafood', '🦐'),
  dairy('Dairy', '🧀'),
  spices('Spices', '🌶️'),
  pantry('Pantry', '🥫');

  const IngredientCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
  });

  final String id;
  final String name;
  final String emoji;
  final IngredientCategory category;
}

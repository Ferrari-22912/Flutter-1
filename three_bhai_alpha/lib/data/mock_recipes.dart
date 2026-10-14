import 'package:three_bhai/models/recipe.dart';

/// Sample recipes for the alpha build. Ingredient names match the names in the
/// ingredient catalog (case-insensitive) so ranking works with any selection.
/// `imageUrl` of the form `emoji:<char>` draws a local emoji tile (no network).
const List<Recipe> mockRecipes = [
  Recipe(
    id: 'm1',
    title: 'Chicken Biryani',
    imageUrl: 'emoji:🍛',
    category: 'Main',
    area: 'Pakistani',
    instructions:
        'Marinate the chicken with yogurt, garam masala, turmeric and salt for 30 minutes.\n'
        'Fry sliced onions in ghee until golden, then add the chicken and tomato and cook until tender.\n'
        'Parboil the rice with cumin and cardamom until 70% done.\n'
        'Layer rice over the chicken, cover tightly and steam on low heat for 20 minutes.\n'
        'Rest for 5 minutes, fluff gently and serve with raita.',
    ingredients: [
      RecipeIngredient(name: 'Chicken', measure: '500 g'),
      RecipeIngredient(name: 'Rice', measure: '2 cups'),
      RecipeIngredient(name: 'Onion', measure: '2 large'),
      RecipeIngredient(name: 'Tomato', measure: '2'),
      RecipeIngredient(name: 'Yogurt', measure: '1/2 cup'),
      RecipeIngredient(name: 'Garam masala', measure: '2 tsp'),
      RecipeIngredient(name: 'Ghee', measure: '3 tbsp'),
      RecipeIngredient(name: 'Salt', measure: 'to taste'),
    ],
  ),
  Recipe(
    id: 'm2',
    title: 'Egg Fried Rice',
    imageUrl: 'emoji:🍚',
    category: 'Main',
    area: 'Chinese',
    instructions:
        'Heat oil in a wok and scramble the eggs, then set them aside.\n'
        'Stir-fry garlic, carrot and peas for 2 minutes.\n'
        'Add cold cooked rice and toss on high heat for 3 minutes.\n'
        'Season with soy sauce and black pepper, fold the eggs back in and serve hot.',
    ingredients: [
      RecipeIngredient(name: 'Rice', measure: '3 cups cooked'),
      RecipeIngredient(name: 'Eggs', measure: '3'),
      RecipeIngredient(name: 'Garlic', measure: '2 cloves'),
      RecipeIngredient(name: 'Carrot', measure: '1 diced'),
      RecipeIngredient(name: 'Green peas', measure: '1/2 cup'),
      RecipeIngredient(name: 'Soy sauce', measure: '2 tbsp'),
      RecipeIngredient(name: 'Cooking oil', measure: '2 tbsp'),
      RecipeIngredient(name: 'Black pepper', measure: '1/2 tsp'),
    ],
  ),
  Recipe(
    id: 'm3',
    title: 'Creamy Tomato Pasta',
    imageUrl: 'emoji:🍝',
    category: 'Pasta',
    area: 'Italian',
    instructions:
        'Boil the pasta in salted water until al dente and reserve a cup of pasta water.\n'
        'Saute garlic and onion in olive oil until soft.\n'
        'Add tomato paste and chopped tomatoes and simmer for 10 minutes.\n'
        'Stir in cream and basil, toss with the pasta and loosen with pasta water.\n'
        'Finish with cheese and black pepper.',
    ingredients: [
      RecipeIngredient(name: 'Pasta', measure: '250 g'),
      RecipeIngredient(name: 'Tomato', measure: '3'),
      RecipeIngredient(name: 'Tomato paste', measure: '2 tbsp'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Cream', measure: '1/2 cup'),
      RecipeIngredient(name: 'Cheese', measure: '50 g'),
      RecipeIngredient(name: 'Basil', measure: 'a handful'),
      RecipeIngredient(name: 'Olive oil', measure: '2 tbsp'),
    ],
  ),
  Recipe(
    id: 'm4',
    title: 'Aloo Gobi Style Potato Curry',
    imageUrl: 'emoji:🥔',
    category: 'Vegetarian',
    area: 'Indian',
    instructions: 'Heat oil and crackle the cumin seeds.\n'
        'Add onion, ginger and garlic and cook until golden.\n'
        'Add tomato, turmeric, chili and salt and cook into a thick masala.\n'
        'Add cubed potatoes and a splash of water, cover and cook for 15 minutes.\n'
        'Finish with garam masala and fresh coriander.',
    ingredients: [
      RecipeIngredient(name: 'Potato', measure: '4 medium'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Tomato', measure: '2'),
      RecipeIngredient(name: 'Ginger', measure: '1 inch'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Cumin', measure: '1 tsp'),
      RecipeIngredient(name: 'Turmeric', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Chili', measure: '1 tsp'),
      RecipeIngredient(name: 'Coriander', measure: 'to garnish'),
      RecipeIngredient(name: 'Cooking oil', measure: '3 tbsp'),
    ],
  ),
  Recipe(
    id: 'm5',
    title: 'Masala Omelette',
    imageUrl: 'emoji:🍳',
    category: 'Breakfast',
    area: 'Pakistani',
    instructions:
        'Beat the eggs with chopped onion, tomato, chili, coriander and salt.\n'
        'Heat butter in a pan over medium heat.\n'
        'Pour in the mixture, cook until the base sets, then flip.\n'
        'Serve hot with paratha or toast.',
    ingredients: [
      RecipeIngredient(name: 'Eggs', measure: '3'),
      RecipeIngredient(name: 'Onion', measure: '1/2'),
      RecipeIngredient(name: 'Tomato', measure: '1/2'),
      RecipeIngredient(name: 'Chili', measure: '1'),
      RecipeIngredient(name: 'Coriander', measure: '2 tbsp'),
      RecipeIngredient(name: 'Butter', measure: '1 tbsp'),
      RecipeIngredient(name: 'Salt', measure: 'a pinch'),
    ],
  ),
  Recipe(
    id: 'm6',
    title: 'Lemon Garlic Salmon',
    imageUrl: 'emoji:🐟',
    category: 'Seafood',
    area: 'Mediterranean',
    instructions: 'Season the salmon with salt and black pepper.\n'
        'Sear skin-side down in olive oil for 4 minutes, then flip.\n'
        'Add butter, garlic and lemon juice and baste for 2 minutes.\n'
        'Serve with the pan sauce and fresh basil.',
    ingredients: [
      RecipeIngredient(name: 'Salmon', measure: '2 fillets'),
      RecipeIngredient(name: 'Lemon', measure: '1'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Butter', measure: '2 tbsp'),
      RecipeIngredient(name: 'Olive oil', measure: '1 tbsp'),
      RecipeIngredient(name: 'Black pepper', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Salt', measure: 'to taste'),
    ],
  ),
  Recipe(
    id: 'm7',
    title: 'Chana Masala',
    imageUrl: 'emoji:🫘',
    category: 'Vegetarian',
    area: 'Indian',
    instructions: 'Saute onion, ginger and garlic in oil until golden.\n'
        'Add tomato, cumin, turmeric, chili and garam masala and cook until the oil separates.\n'
        'Add boiled chickpeas and a cup of water and simmer for 20 minutes.\n'
        'Squeeze in lemon and garnish with coriander.',
    ingredients: [
      RecipeIngredient(name: 'Chickpeas', measure: '2 cups boiled'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Tomato', measure: '2'),
      RecipeIngredient(name: 'Ginger', measure: '1 inch'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Cumin', measure: '1 tsp'),
      RecipeIngredient(name: 'Turmeric', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Garam masala', measure: '1 tsp'),
      RecipeIngredient(name: 'Lemon', measure: '1/2'),
      RecipeIngredient(name: 'Cooking oil', measure: '3 tbsp'),
    ],
  ),
  Recipe(
    id: 'm8',
    title: 'Chicken Karahi',
    imageUrl: 'emoji:🍗',
    category: 'Main',
    area: 'Pakistani',
    instructions:
        'Heat oil and fry the chicken pieces with garlic and ginger until lightly browned.\n'
        'Add chopped tomatoes, chili, salt and black pepper and cook covered until the tomatoes break down.\n'
        'Stir on high heat until the oil separates.\n'
        'Finish with ginger strips, coriander and a pinch of garam masala.',
    ingredients: [
      RecipeIngredient(name: 'Chicken', measure: '750 g'),
      RecipeIngredient(name: 'Tomato', measure: '4'),
      RecipeIngredient(name: 'Ginger', measure: '2 inch'),
      RecipeIngredient(name: 'Garlic', measure: '5 cloves'),
      RecipeIngredient(name: 'Chili', measure: '4 green'),
      RecipeIngredient(name: 'Black pepper', measure: '1 tsp'),
      RecipeIngredient(name: 'Garam masala', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Coriander', measure: 'to garnish'),
      RecipeIngredient(name: 'Cooking oil', measure: '1/2 cup'),
    ],
  ),
  Recipe(
    id: 'm9',
    title: 'Banana Oat Pancakes',
    imageUrl: 'emoji:🥞',
    category: 'Breakfast',
    area: 'American',
    instructions: 'Mash the banana and whisk in the eggs and milk.\n'
        'Stir in oats, flour and baking powder until just combined.\n'
        'Cook spoonfuls on a buttered pan over medium heat until bubbles form, then flip.\n'
        'Serve with honey.',
    ingredients: [
      RecipeIngredient(name: 'Banana', measure: '2 ripe'),
      RecipeIngredient(name: 'Oats', measure: '1 cup'),
      RecipeIngredient(name: 'Eggs', measure: '2'),
      RecipeIngredient(name: 'Milk', measure: '1/2 cup'),
      RecipeIngredient(name: 'Flour', measure: '1/2 cup'),
      RecipeIngredient(name: 'Baking powder', measure: '1 tsp'),
      RecipeIngredient(name: 'Butter', measure: '1 tbsp'),
      RecipeIngredient(name: 'Honey', measure: 'to drizzle'),
    ],
  ),
  Recipe(
    id: 'm10',
    title: 'Greek Salad',
    imageUrl: 'emoji:🥗',
    category: 'Salad',
    area: 'Greek',
    instructions: 'Chop the tomato, cucumber and onion into chunky pieces.\n'
        'Add olives and crumbled cheese.\n'
        'Dress with olive oil, oregano, vinegar, salt and pepper and toss gently.',
    ingredients: [
      RecipeIngredient(name: 'Tomato', measure: '3'),
      RecipeIngredient(name: 'Cucumber', measure: '1'),
      RecipeIngredient(name: 'Onion', measure: '1/2 red'),
      RecipeIngredient(name: 'Olives', measure: '1/2 cup'),
      RecipeIngredient(name: 'Cheese', measure: '100 g feta'),
      RecipeIngredient(name: 'Olive oil', measure: '3 tbsp'),
      RecipeIngredient(name: 'Oregano', measure: '1 tsp'),
      RecipeIngredient(name: 'Vinegar', measure: '1 tbsp'),
    ],
  ),
  Recipe(
    id: 'm11',
    title: 'Dal Tadka',
    imageUrl: 'emoji:🍲',
    category: 'Vegetarian',
    area: 'Pakistani',
    instructions:
        'Boil lentils with turmeric and salt until soft and mash lightly.\n'
        'Heat ghee, crackle cumin, then fry garlic, onion and chili.\n'
        'Pour the tadka over the dal, add tomato and simmer for 5 minutes.\n'
        'Garnish with coriander and serve with rice or roti.',
    ingredients: [
      RecipeIngredient(name: 'Lentils', measure: '1 cup'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Tomato', measure: '1'),
      RecipeIngredient(name: 'Garlic', measure: '4 cloves'),
      RecipeIngredient(name: 'Cumin', measure: '1 tsp'),
      RecipeIngredient(name: 'Turmeric', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Chili', measure: '2 dried'),
      RecipeIngredient(name: 'Ghee', measure: '2 tbsp'),
      RecipeIngredient(name: 'Coriander', measure: 'to garnish'),
    ],
  ),
  Recipe(
    id: 'm12',
    title: 'Beef Stir-Fry with Peppers',
    imageUrl: 'emoji:🥩',
    category: 'Main',
    area: 'Asian',
    instructions:
        'Slice the beef thinly and marinate with soy sauce and black pepper.\n'
        'Sear on very high heat for 2 minutes and set aside.\n'
        'Stir-fry bell pepper, onion, garlic and ginger for 3 minutes.\n'
        'Return the beef, toss with the sauce and serve over rice or noodles.',
    ingredients: [
      RecipeIngredient(name: 'Beef', measure: '400 g'),
      RecipeIngredient(name: 'Bell pepper', measure: '2'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Ginger', measure: '1 inch'),
      RecipeIngredient(name: 'Soy sauce', measure: '3 tbsp'),
      RecipeIngredient(name: 'Black pepper', measure: '1/2 tsp'),
      RecipeIngredient(name: 'Cooking oil', measure: '2 tbsp'),
    ],
  ),
  Recipe(
    id: 'm13',
    title: 'Palak Paneer',
    imageUrl: 'emoji:🥬',
    category: 'Vegetarian',
    area: 'Indian',
    instructions:
        'Blanch the spinach for 2 minutes, then blend into a smooth puree.\n'
        'Saute onion, garlic and ginger in ghee, add tomato and spices.\n'
        'Stir in the spinach puree and a splash of cream.\n'
        'Add cubed paneer and simmer for 5 minutes.',
    ingredients: [
      RecipeIngredient(name: 'Spinach', measure: '400 g'),
      RecipeIngredient(name: 'Paneer', measure: '200 g'),
      RecipeIngredient(name: 'Onion', measure: '1'),
      RecipeIngredient(name: 'Tomato', measure: '1'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Ginger', measure: '1 inch'),
      RecipeIngredient(name: 'Cream', measure: '2 tbsp'),
      RecipeIngredient(name: 'Garam masala', measure: '1 tsp'),
      RecipeIngredient(name: 'Ghee', measure: '2 tbsp'),
    ],
  ),
  Recipe(
    id: 'm14',
    title: 'Mushroom Garlic Toast',
    imageUrl: 'emoji:🍞',
    category: 'Snack',
    area: 'French',
    instructions: 'Saute sliced mushrooms in butter with garlic until golden.\n'
        'Season with salt, black pepper and a squeeze of lemon.\n'
        'Toast the bread and pile the mushrooms on top.\n'
        'Finish with cheese and basil.',
    ingredients: [
      RecipeIngredient(name: 'Bread', measure: '4 slices'),
      RecipeIngredient(name: 'Mushroom', measure: '200 g'),
      RecipeIngredient(name: 'Garlic', measure: '2 cloves'),
      RecipeIngredient(name: 'Butter', measure: '2 tbsp'),
      RecipeIngredient(name: 'Lemon', measure: '1/2'),
      RecipeIngredient(name: 'Cheese', measure: '40 g'),
      RecipeIngredient(name: 'Black pepper', measure: '1/4 tsp'),
    ],
  ),
  Recipe(
    id: 'm15',
    title: 'Shrimp Fried Noodles',
    imageUrl: 'emoji:🍜',
    category: 'Seafood',
    area: 'Asian',
    instructions: 'Cook the noodles, drain and toss with a little oil.\n'
        'Stir-fry shrimp with garlic until pink, then add cabbage and carrot.\n'
        'Add the noodles and soy sauce and toss on high heat.\n'
        'Finish with black pepper and serve immediately.',
    ingredients: [
      RecipeIngredient(name: 'Noodles', measure: '200 g'),
      RecipeIngredient(name: 'Shrimp', measure: '250 g'),
      RecipeIngredient(name: 'Garlic', measure: '3 cloves'),
      RecipeIngredient(name: 'Cabbage', measure: '1 cup shredded'),
      RecipeIngredient(name: 'Carrot', measure: '1'),
      RecipeIngredient(name: 'Soy sauce', measure: '3 tbsp'),
      RecipeIngredient(name: 'Cooking oil', measure: '2 tbsp'),
      RecipeIngredient(name: 'Black pepper', measure: '1/2 tsp'),
    ],
  ),
];

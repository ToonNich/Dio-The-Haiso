import 'recipe_model.dart';

class RecipeRepository {
  // Mock data
  final List<Recipe> _recipes = [
    Recipe(title: 'Spaghetti', ingredients: ['pasta', 'tomato', 'beef']),
    Recipe(title: 'Salad', ingredients: ['lettuce', 'tomato', 'cucumber']),
    Recipe(title: 'Omelette', ingredients: ['egg', 'cheese', 'tomato']),
  ];

  Future<List<Recipe>> searchByIngredient(String ingredient) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    final results = _recipes.where((r) => r.ingredients.contains(ingredient.toLowerCase())).toList();
    if (results.isEmpty) throw Exception('No recipes found');
    return results;
  }
}

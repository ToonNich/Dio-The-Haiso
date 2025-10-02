import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';
import 'auth_repository.dart';
import 'recipe_cubit.dart';
import 'recipe_repository.dart';
import 'login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final RecipeRepository recipeRepository = RecipeRepository();
  final AuthRepository authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RecipeCubit(recipeRepository)),
        BlocProvider(create: (_) => AuthCubit(authRepository)),
      ],
      child: MaterialApp(home: RecipeFinderPage()),
    );
  }
}

class RecipeFinderPage extends StatelessWidget {
  RecipeFinderPage({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Finder (Cubit Example)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter ingredient'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final ingredient = _controller.text.trim().toLowerCase();
                if (ingredient.isEmpty) return;

                final authCubit = context.read<AuthCubit>();

                if (!authCubit.isLoggedIn) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
                if (authCubit.isLoggedIn) {
                  context.read<RecipeCubit>().search(ingredient);
                }
              },
              child: const Text('Search Recipes'),
            ),
            const SizedBox(height: 32),
            BlocBuilder<RecipeCubit, RecipeState>(
              builder: (context, state) {
                if (state is RecipeInitial) {
                  return const Text('Enter an ingredient to search recipes');
                } else if (state is RecipeLoading) {
                  return const CircularProgressIndicator();
                } else if (state is RecipeLoaded) {
                  return Column(
                    children:
                        state.recipes
                            .map(
                              (r) => Card(
                                child: ListTile(
                                  title: Text(r.title),
                                  subtitle: Text(
                                    'Ingredients: ${r.ingredients.join(', ')}',
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  );
                } else if (state is RecipeError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

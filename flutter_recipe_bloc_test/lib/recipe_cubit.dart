import 'package:flutter_bloc/flutter_bloc.dart';
import 'recipe_model.dart';
import 'recipe_repository.dart';
import 'package:equatable/equatable.dart';

abstract class RecipeState extends Equatable{
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  RecipeLoaded(this.recipes);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository repository;
  RecipeCubit(this.repository) : super(RecipeInitial());

  void search(String ingredient) async {
    emit(RecipeLoading());
    try {
      final recipes = await repository.searchByIngredient(ingredient);
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_bloc/recipe_cubit.dart';
import 'package:flutter_weather_bloc/recipe_model.dart';
import 'package:flutter_weather_bloc/recipe_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'recipe_cubit_test.mocks.dart';

@GenerateMocks([RecipeRepository])
void main() {
  //Group of WeatherRepositoryเพื่อกดrunจะได้ง่าย จะrunทั้งgroup
  group('RecipeCubit', () {
    late MockRecipeRepository mockRepository;
    late RecipeCubit cubit;

    // 1st excute
    setUp(() {
      //Generate Mock
      mockRepository = MockRecipeRepository();
      //Generate Cubit
      cubit = RecipeCubit(mockRepository);
    });

    // 2nd Excute

    blocTest<RecipeCubit, RecipeState>(
      'emits [RecipeLoading, RecipeLoaded] when searchByIngredient succeeds',
      build: () {
        when(mockRepository.searchByIngredient('tomato')).thenAnswer(
          (_) async => [
            Recipe(
              title: 'Spaghetti',
              ingredients: ['pasta', 'tomato', 'beef'],
            ),
          ],
        );
        return cubit;
      },
      act: (cubit) => cubit.search('tomato'),
      expect:
          () => [
            RecipeLoading(),
            RecipeLoaded([
              Recipe(
                title: 'Spaghetti',
                ingredients: ['pasta', 'tomato', 'beef'],
              ),
            ]),
          ],
    );
    
    blocTest<RecipeCubit, RecipeState>(
      'emits [RecipeLoading, RecipeError] when searchByIngredient throws',
      build: () {
        when(
          mockRepository.searchByIngredient('tomato'),
        ).thenThrow(Exception('error'));
        return cubit;
      },
      act: (cubit) => cubit.search('tomato'),
      expect: () => [RecipeLoading(), isA<RecipeError>()],
    );

    // 3rd Excute
    // Test จบต้องปิดตัวCubitด้วย เวลาจะไปทำtestตัวอื่น
    tearDown(() {
      cubit.close();
    });
  });
}

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:recipes/Services/Recipe/RecipeUseCase.dart';

void main() {

  const pageSize = 10;

  group('Real API', () {

    final recipeUseCase = RecipeUseCase();
    final timeout = Timeout(Duration(seconds: 10));

    const basicEmptyQuery = RecipeQuery(ingredients: "", query: "", page: 1);

    test('Fetching recipes Not EMPTY', () async {
      final recipes = await recipeUseCase.fetch(basicEmptyQuery);
      expect(recipes.isNotEmpty, true);
    }, timeout: timeout);

    test('Fetching recipes COUNT', () async {
      final recipes = await recipeUseCase.fetch(basicEmptyQuery);
      expect(recipes.length, pageSize);
    }, timeout: timeout);

    test('Different recipes for diferent pages', () async {
      final recipesPage1 = await recipeUseCase.fetch(basicEmptyQuery);
      final recipesPage2 = await recipeUseCase.fetch(basicEmptyQuery.copyWith(page: 2));
      expect(listEquals(recipesPage1, recipesPage2), false);
      expect(recipesPage1.length, recipesPage2.length);
    }, timeout: timeout);

    test('Multi fetch recipes', () async {
      final noPagesRecipes = await recipeUseCase.multiFetch(ingredients: "", query: "", pages: []);
      final onePage = await recipeUseCase.multiFetch(ingredients: "", query: "", pages: [1]);
      final twoPages = await recipeUseCase.multiFetch(ingredients: "", query: "", pages: [1, 2]);
      final threePages = await recipeUseCase.multiFetch(ingredients: "", query: "", pages: [1, 2, 3]);

      expect(noPagesRecipes.length, 0);
      expect(onePage.length, pageSize);
      expect(twoPages.length, pageSize * 2);
      expect(threePages.length, pageSize * 3);
    }, timeout: Timeout(Duration(seconds: 25)));
  });
}

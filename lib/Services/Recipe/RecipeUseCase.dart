import 'package:recipes/Models/Recipe.dart';
import 'package:recipes/Services/Recipe/Repository/RecipeRepository.dart';

import 'package:dio/dio.dart';

class RecipeUseCase {

  static Future<List<Recipe>> fetch({ingredients: String, query: String, page: int}) async {
    try {
      final response = await RecipeRepository.fetch(ingredients: ingredients, query: query, page: page);
      return Recipe.fromResponse(response);
    } on DioError catch(e) {
      print(e.message);
      return [];
    }
  }

  static Future<List<Recipe>> multiFetch({ingredients: String, query: String, List<int> pages}) async {
    try {
      if (pages.isEmpty) { return []; }
      List<Recipe> recipes = [];
      for (final page in pages) {
        recipes.addAll(await RecipeUseCase.fetch(ingredients: ingredients, query: query, page: page));
      }
      return recipes;
    } on DioError catch(e) {
      print(e.message);
      return [];
    }
  }

  static void cancel() {
    RecipeRepository.cancelRequest();
  }
}
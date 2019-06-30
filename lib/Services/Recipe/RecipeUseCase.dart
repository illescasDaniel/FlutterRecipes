import 'package:dio/dio.dart';
import 'package:recipes/Models/Recipe.dart';
import 'package:recipes/Services/Recipe/Client/RecipeClient.dart';
import 'package:recipes/Services/Recipe/Client/RecipeResponse.dart';
import 'package:recipes/Models/Mappers/RecipeMapper.dart';
import 'package:recipes/lib/Network/UseCase.dart';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class RecipeQuery {
  final String ingredients;
  final String query;
  final int page;
  const RecipeQuery({this.ingredients = "", this.query = "", this.page = 1})
      : assert(ingredients != null), assert(query != null), assert(page != null);
  RecipeQuery copyWith({String ingredients, String query, int page}) =>
    RecipeQuery(
      ingredients: ingredients ?? this.ingredients,
      query: query ?? this.query,
      page: page ?? this.page
    );
}

abstract class MixinRecipeUseCase {
  Future<List<Recipe>> fetch(RecipeQuery recipeQuery);
  Future<List<Recipe>> multiFetch({ingredients: String, query: String, List<int> pages});
}

class RecipeUseCase with UseCase implements MixinRecipeUseCase {

  RecipeClient _recipeClient;

  RecipeUseCase({RecipeClient recipeClient}) {
    this.setupHttpClient(options: this.defaultOptions);
    this._recipeClient = recipeClient ?? RecipeClient.instance(httpClient);
  }

  //

  Future<List<Recipe>> fetch(RecipeQuery recipeQuery) async {
    try {
      final response = await this._recipeClient.fetch(
        ingredients: recipeQuery.ingredients,
        query: recipeQuery.query,
        page: recipeQuery.page
      );
      return RecipeMapper.fromResponse(RecipeResponse.fromJson(response.data));
    } on DioError catch(_) {
      return [];
    } on Exception catch(e) {
      print(e.toString());
      return [];
    } catch(e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<Recipe>> multiFetch({ingredients: String, query: String, List<int> pages}) async {

    if (pages.isEmpty) {
      assert(true, "Pages can't be empty!");
      return [];
    }

    final goodPages = pages.where((page) => page > 0);
    assert(goodPages.length == pages.length, "Some pages have bad number!");

    final recipes = <Recipe>[];
    for (final page in goodPages) {
      recipes.addAll(await this.fetch(RecipeQuery(ingredients: ingredients, query: query, page: page)));
    }

    return recipes;
  }
}

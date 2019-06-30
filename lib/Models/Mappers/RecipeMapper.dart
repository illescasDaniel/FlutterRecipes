import 'package:flutter/foundation.dart';
import 'package:recipes/Models/Recipe.dart';
import 'package:recipes/Services/Recipe/Client/RecipeResponse.dart';

class RecipeMapper {

  static Recipe from({@required RecipeResponseResult result}) {

    assert(result != null, "A recipe result can't be null!");
    assert(result.title != null, "A recipe title can't be null!");
    assert(result.href!= null, "A recipe link can't be null!");
    assert(result.ingredients != null, "Recipe ingredients can't be null!");

    final parsedRecipeLink = Uri.parse(result?.href ?? "");
    final parsedThumbnailLink = Uri.parse(result?.thumbnail ?? "");
    return Recipe(
        title: result.title.trim(),
        link: parsedRecipeLink,
        ingredients: result.ingredients.trim(),
        thumbnail: parsedThumbnailLink
    );
  }

  static List<Recipe> fromResponse(RecipeResponse response) {
    if (response == null) { return []; }
    return response.results.map((result) => RecipeMapper.from(result: result))
        .toList();
  }
}

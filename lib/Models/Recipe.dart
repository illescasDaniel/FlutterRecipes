import 'package:recipes/Services/Recipe/Repository/RecipeResponse.dart';

class Recipe {

  final String title;
  final String link;
  final String ingredients;
  final String thumbnail;

  Recipe({this.title, this.link, this.ingredients, this.thumbnail});

  @override
  bool operator==(Object other) {
    return identical(this, other) || (other is Recipe && this.link.toLowerCase() == other.link.toLowerCase());
  }

  @override
  int get hashCode {
    return this.link.toLowerCase().hashCode;
  }

  factory Recipe.mappedFrom(RecipeResponseResult result) {
    return Recipe(
        title: result.title.trim(),
        link: result.href,
        ingredients: result.ingredients.trim(),
        thumbnail: result.thumbnail
    );
  }
  static List<Recipe> fromResponse(RecipeResponse response) {
    return response.results.map((result) => Recipe.mappedFrom(result)).toList();
  }
}
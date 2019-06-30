
/*
"title": "Recipe Puppy",
"version": 0.1,
"href": "http://www.recipepuppy.com/",
"results": [
    {
        "title": "Grilled Italian Chicken Breasts \r\n\t\t\n",
        "href": "http://www.kraftfoods.com/kf/recipes/grilled-italian-chicken-breasts-57825.aspx",
        "ingredients": "garlic, bread crumbs, chicken, butter",
        "thumbnail": "http://img.recipepuppy.com/602998.jpg"
    },
**/
import 'package:flutter/foundation.dart' show immutable;
import 'package:json_annotation/json_annotation.dart';

part 'RecipeResponse.g.dart';

@immutable
@JsonSerializable(
  nullable: false,
  createToJson: false
)
class RecipeResponse {

  final String title;
  final double version;
  final String href;
  final List<RecipeResponseResult> results;

  RecipeResponse({this.title, this.version, this.href, this.results});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => _$RecipeResponseFromJson(json);
}

@immutable
@JsonSerializable(
  nullable: false,
  createToJson: false
)
class RecipeResponseResult {

  final String title;
  final String href;
  final String ingredients;
  final String thumbnail;

  RecipeResponseResult({this.title, this.href, this.ingredients, this.thumbnail});

  factory RecipeResponseResult.fromJson(Map<String, dynamic> json) => _$RecipeResponseResultFromJson(json);
}

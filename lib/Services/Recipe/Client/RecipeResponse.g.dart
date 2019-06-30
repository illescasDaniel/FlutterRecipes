// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecipeResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeResponse _$RecipeResponseFromJson(Map<String, dynamic> json) {
  return RecipeResponse(
      title: json['title'] as String,
      version: (json['version'] as num).toDouble(),
      href: json['href'] as String,
      results: (json['results'] as List)
          .map((e) => RecipeResponseResult.fromJson(e as Map<String, dynamic>))
          .toList());
}

RecipeResponseResult _$RecipeResponseResultFromJson(Map<String, dynamic> json) {
  return RecipeResponseResult(
      title: json['title'] as String,
      href: json['href'] as String,
      ingredients: json['ingredients'] as String,
      thumbnail: json['thumbnail'] as String);
}

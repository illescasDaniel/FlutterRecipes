import 'package:flutter/cupertino.dart';
import 'package:recipes/Models/Recipe.dart';

enum RecipeResultsType {
  firstLoad,
  hasErrors,
  emptyOrNullResults,
  hasData
}
class RecipeResultsSnapshotType {
  static RecipeResultsType from(AsyncSnapshot<List<Recipe>> snapshot) {
    if (snapshot.data == null && snapshot.connectionState == ConnectionState.waiting) {
      return RecipeResultsType.firstLoad;
    }

    if (snapshot.hasError) {
      return RecipeResultsType.hasErrors;
    }

    if (snapshot.data == null || snapshot.data?.isEmpty == true) {
      return RecipeResultsType.emptyOrNullResults;
    }

    return RecipeResultsType.hasData;
  }
}
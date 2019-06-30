import 'package:flutter/material.dart';
import 'Pages/RecipeSearch/RecipeSearchScreen.dart';

void main() => runApp(RecipesApp());

class RecipesApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: TextTheme(
          subhead: TextStyle(
            fontWeight: FontWeight.w500
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
          ),
        )
      ),
      home: RecipeSearchScreen(title: 'Recipes'),
    );
  }
}

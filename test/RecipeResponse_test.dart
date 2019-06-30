import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:recipes/Services/Recipe/RecipeUseCase.dart';
import 'package:recipes/Services/Recipe/Client/RecipeClient.dart';
import 'package:recipes/Services/Recipe/Client/RecipeResponse.dart';

class MockRecipeClient extends Mock implements RecipeClient {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() async {
  const pageSize = 10;

  group('Mock recipes', () {

    const basicEmptyQuery = RecipeQuery(ingredients: "", query: "", page: 1);

    final mockRecipeClient = MockRecipeClient();
    final mockResponse = MockResponse<Map<String, dynamic>>();
    when(mockResponse.data)
      .thenReturn(json.decode("""
      {"title":"Recipe Puppy","version":0.1,"href":"http:\/\/www.recipepuppy.com\/","results":[{"title":"Ginger Champagne","href":"http:\/\/allrecipes.com\/Recipe\/Ginger-Champagne\/Detail.aspx","ingredients":"champagne, ginger, ice, vodka","thumbnail":"http:\/\/img.recipepuppy.com\/1.jpg"},{"title":"Potato and Cheese Frittata","href":"http:\/\/allrecipes.com\/Recipe\/Potato-and-Cheese-Frittata\/Detail.aspx","ingredients":"cheddar cheese, eggs, olive oil, onions, potato, salt","thumbnail":"http:\/\/img.recipepuppy.com\/2.jpg"},{"title":"Eggnog Thumbprints","href":"http:\/\/allrecipes.com\/Recipe\/Eggnog-Thumbprints\/Detail.aspx","ingredients":"brown sugar, butter, butter, powdered sugar, eggs, flour, nutmeg, rum, salt, vanilla extract, sugar","thumbnail":"http:\/\/img.recipepuppy.com\/3.jpg"},{"title":"Succulent Pork Roast","href":"http:\/\/allrecipes.com\/Recipe\/Succulent-Pork-Roast\/Detail.aspx","ingredients":"brown sugar, garlic, pork chops, water","thumbnail":"http:\/\/img.recipepuppy.com\/4.jpg"},{"title":"Irish Champ","href":"http:\/\/allrecipes.com\/Recipe\/Irish-Champ\/Detail.aspx","ingredients":"black pepper, butter, green onion, milk, potato, salt","thumbnail":"http:\/\/img.recipepuppy.com\/5.jpg"},{"title":"Chocolate-Cherry Thumbprints","href":"http:\/\/allrecipes.com\/Recipe\/Chocolate-Cherry-Thumbprints\/Detail.aspx","ingredients":"cocoa powder, baking powder, butter, eggs, flour, oats, salt, sugar, vanilla extract","thumbnail":"http:\/\/img.recipepuppy.com\/6.jpg"},{"title":"Mean Woman Pasta","href":"http:\/\/allrecipes.com\/Recipe\/Mean-Woman-Pasta\/Detail.aspx","ingredients":"garlic, kalamata olive, olive oil, pepperoncini, seashell pasta, tomato","thumbnail":"http:\/\/img.recipepuppy.com\/7.jpg"},{"title":"Hot Spiced Cider","href":"http:\/\/allrecipes.com\/Recipe\/Hot-Spiced-Cider\/Detail.aspx","ingredients":"allspice, apple cider, brown sugar, cinnamon, cloves, nutmeg, orange, salt","thumbnail":"http:\/\/img.recipepuppy.com\/8.jpg"},{"title":"Isa's Cola de Mono","href":"http:\/\/allrecipes.com\/Recipe\/Isas-Cola-de-Mono\/Detail.aspx","ingredients":"cinnamon, cloves, instant coffee, milk, rum, vanilla extract, water, sugar","thumbnail":"http:\/\/img.recipepuppy.com\/9.jpg"},{"title":"Amy's Barbecue Chicken Salad","href":"http:\/\/allrecipes.com\/Recipe\/Amys-Barbecue-Chicken-Salad\/Detail.aspx","ingredients":"barbecue sauce, chicken, cilantro, lettuce, ranch dressing, lettuce, tomato","thumbnail":"http:\/\/img.recipepuppy.com\/10.jpg"}]}
      """));
    when(mockRecipeClient.fetch(
        ingredients: basicEmptyQuery.ingredients,
        query: basicEmptyQuery.query,
        page: basicEmptyQuery.page
    ))
    .thenAnswer((_) => Future.value(mockResponse));

    //

    final mockRecipeUseCase = RecipeUseCase(recipeClient: mockRecipeClient);

    //

    group('Basic fetching', () {
      test('Fetching (mock) recipes Not EMPTY', () async {
        final recipes = await mockRecipeUseCase.fetch(basicEmptyQuery);
        expect(recipes.isNotEmpty, true);
      });

      test('Fetching (mock) recipes COUNT', () async {
        final recipes = await mockRecipeUseCase.fetch(basicEmptyQuery);
        expect(recipes.length, pageSize);
      });
    });

    group('Recipe Serialization', () {

      final responseFn = () => mockRecipeClient.fetch(ingredients: "", query: "", page: 1);

      test('Response and data', () async {
        final response = await responseFn();
        print(response);
        expect(response != null, true);
        final responseData = response.data;
        expect(responseData != null, true);
        expect(responseData.isNotEmpty, true);
      });

      test('JSON Mapping', () async {
        final response = await responseFn();
        Map<String, dynamic> decodedResponse = response.data;
        expect(decodedResponse != null, true);
        expect(decodedResponse.isNotEmpty, true);
      });

      test('Object Mapping', () async{
        final response = await responseFn();
        Map<String, dynamic> decodedResponse = response.data;
        final recipeResponse = RecipeResponse.fromJson(decodedResponse);
        expect(recipeResponse != null, true);
        expect(recipeResponse.results.isNotEmpty, true);
        expect(recipeResponse.results.length, 10);

        expect(recipeResponse.results.first != null, true);
        expect(recipeResponse.results.first.title.trim().isNotEmpty, true);

      });
    });

  });
}
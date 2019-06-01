import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:recipes/Services/Recipe/Repository/RecipeResponse.dart';

class RecipeRepository {

  static final _dio = Dio(
      BaseOptions(
        connectTimeout: 10000,
        receiveTimeout: 8000,
      )
  );
  static final CancelToken _token = new CancelToken();

  static Future<RecipeResponse> fetch({ingredients: String, query: String, page: int}) async {

    final url = Uri.http("www.recipepuppy.com", "/api", { "i" : ingredients, "q" : query, "p": page.toString() });

    try {
      final response = await _dio.getUri(url, cancelToken: _token);
      final jsonData = json.decode(response.data);
      return RecipeResponse.from(json: jsonData);
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  static void cancelRequest() {
    _token.cancel("cancelled");
  }
}
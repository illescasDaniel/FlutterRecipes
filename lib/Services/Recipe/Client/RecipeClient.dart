import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'RecipeClient.g.dart';

@RestApi(baseUrl: "http://www.recipepuppy.com/api/")
abstract class RecipeClient {

  factory RecipeClient.instance(Dio dio) => _RecipeClient(dio);

  @GET("/")
  @Headers({ "Accept": "application/json" })
  Future<Response<Map<String, dynamic>>> fetch({
    @Query("i") String ingredients,
    @Query("q") String query,
    @Query("p") int page
  });
}

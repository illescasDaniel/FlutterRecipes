// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecipeClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RecipeClient implements RecipeClient {
  _RecipeClient([this._dio]) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'http://www.recipepuppy.com/api/';
  }

  final Dio _dio;

  @override
  fetch({ingredients, query, page}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'i': ingredients,
      'q': query,
      'p': page
    };
    const _data = null;
    return _dio.request('/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: {'Accept': 'application/json'},
            extra: _extra),
        data: _data);
  }
}

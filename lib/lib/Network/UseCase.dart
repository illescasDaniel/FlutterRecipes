import 'package:dio/dio.dart';
import 'package:recipes/lib/Network/JSONTransformer.dart';

mixin UseCase {

  final httpClient = Dio();

  final CancelToken _token = CancelToken();

  void setupHttpClient({BaseOptions options}) {
    this.httpClient
      ..options = options
      ..transformer = JSONTransformer()
      ..interceptors
        .add(InterceptorsWrapper(
          onRequest: (request) {
            request.cancelToken = _token;
            return request;
          },
          onError: (DioError e) {
            print(e.message);
            return e;
          }
        ));
  }

  get defaultOptions => BaseOptions(
    receiveDataWhenStatusError: false,
    connectTimeout: 10000,
    receiveTimeout: 8000,
  );

  void cancelRequest() {
    _token.cancel("Fetch request cancelled");
  }
}

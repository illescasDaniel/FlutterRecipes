import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:super_ranges/super_ranges.dart' show Range;

class JSONTransformer extends DefaultTransformer {

  JSONTransformer() : super(jsonDecodeCallback: _parseJson);

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    if (Range(200,300).contains(response?.statusCode ?? 0)) {
        return super.transformResponse(options, response);
    }
    return null;
  }
}

// Must be top-level function
_parseAndDecode(String response) {
  if (response == null) {
    return null;
  }
  return jsonDecode(response);
}

_parseJson(String text) async {
  return compute(_parseAndDecode, text);
}
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Recipe {

  final String title;
  final Uri link;
  final String ingredients;
  final Uri thumbnail;

  const Recipe({this.title, this.link, this.ingredients, this.thumbnail});

  @override
  bool operator==(Object other) {
    return identical(this, other) ||
        (other is Recipe && this.link.toString().toLowerCase() == other.link.toString().toLowerCase());
  }

  @override
  int get hashCode {
    return this.link.toString().toLowerCase().hashCode;
  }
}

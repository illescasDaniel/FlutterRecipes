import 'package:flutter/material.dart';

class MediaQueryUtils {
  static double recommendedItemsWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size == null) { return null; }
    return size.width > 720.0 ? 720.0 : size.width;
  }
}
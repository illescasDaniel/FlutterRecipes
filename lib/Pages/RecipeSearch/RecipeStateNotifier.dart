import 'package:flutter/foundation.dart';

class RecipeStateNotifier with ChangeNotifier {

  String _searchQuery = "";
  String _ingredients = "";
  int _page = 1;
  bool _wantToScrollToTop = false;

  String get searchQuery => this._searchQuery;
  set searchQuery(String query) {
    this._searchQuery = query;
    this.resetPage(notify: false);
    this.resetIngredients(notify: false);
    this.notifyListeners();
  }

  String get ingredients => this._ingredients;
  set ingredients(String newIngredients) {
    this._ingredients = newIngredients;
    this.resetPage(notify: false);
    this.notifyListeners();
  }

  int get page => this._page;
  set page(int newPage) {
    assert(newPage > 0, "Page MUST be greater than 0");
    this._page = newPage;
    this.notifyListeners();
  }

  bool get wantToScrollToTop => this._wantToScrollToTop;
  set wantToScrollToTop(bool wantToScroll) {
    this._wantToScrollToTop = wantToScroll;
    this.notifyListeners();
  }

  void resetPage({bool notify = true}) {
    if (notify) {
      this.page = 1;
    } else {
      this._page = 1;
    }
  }

  void resetQuery({bool notify = true}) {
    if (notify) {
      this.searchQuery = "";
    } else {
      this._searchQuery = "";
    }
  }

  void resetIngredients({bool notify = true}) {
    if (notify) {
      this.ingredients = "";
    } else {
      this._ingredients = "";
    }
  }

  void resetScrollToTop() {
    this._wantToScrollToTop = false;
  }
}

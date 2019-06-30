import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:recipes/Models/Recipe.dart';
import 'package:recipes/Pages/RecipeSearch/Utils/RecipeResultsType.dart';
import 'package:recipes/Pages/RecipeSearch/RecipeStateNotifier.dart';
import 'package:recipes/Services/Recipe/RecipeUseCase.dart';

import 'package:provider/provider.dart';
import 'package:recipes/Utils/MediaQueryUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeResultList extends StatefulWidget {

  final RecipeUseCase recipeUseCase;

  RecipeResultList({@required this.recipeUseCase})
      : assert(recipeUseCase != null);

  @override
  _RecipeResultListState createState() => _RecipeResultListState();
}

class _RecipeResultListState extends State<RecipeResultList> {

  static const int _pageSize = 10;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  bool _isLoadingFromScroll = false;
  bool _hasMoreRecipes = true;

  List<Recipe> _recipes = [];
  ScrollController _scrollController;

  @override
  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // - Widget building

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeStateNotifier>(
      builder: (context, state, _) => FutureBuilder<List<Recipe>>(
        future: _fetchRecipes(state),
        builder: (context, snapshot) {
          _scrollController ??= PrimaryScrollController.of(context)..addListener(() {
            _scrollListener(state);
          });
          if (state.wantToScrollToTop) {
            _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: ElasticOutCurve());
            state.resetScrollToTop();
          }
          return _results(context: context, state: state, snapshot: snapshot);
        },
      ),
    );
  }

  Widget _results({BuildContext context, RecipeStateNotifier state, AsyncSnapshot<List<Recipe>> snapshot}) {

    switch (RecipeResultsSnapshotType.from(snapshot)) {

      case RecipeResultsType.firstLoad:
        return Center(child: CircularProgressIndicator());

      case RecipeResultsType.hasErrors:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("An error ocurred"),
              FlatButton(
                child: Text("Reload"),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  _onReload(state);
                },
              )
            ],
          )
        );

      case RecipeResultsType.emptyOrNullResults:
        if (!_isLoadingFromScroll) {
          return Center(child: CircularProgressIndicator());
        }
        final text = (state.searchQuery.isNotEmpty || state.ingredients.isNotEmpty)
            ? "No Results" : "Empty";
        return Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.title
          ),
        );

      case RecipeResultsType.hasData:
        return RefreshIndicator(
          onRefresh: () async {
            return _onReload(state);
          },
          key: _refreshIndicatorKey,
          child: Scrollbar(
            child: Container(
              width: MediaQueryUtils.recommendedItemsWidth(context),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                controller: _scrollController,
                itemCount: _recipes.length + (_hasMoreRecipes ? _pageSize*2 : 0), // (snapshot.data ?? recipes).length,
                itemBuilder: (context, index) {
                  final hasRealData = snapshot.hasData && snapshot.data.length > index;
                  return Card(
                    elevation: 2,
                    child: hasRealData
                      ? _listItem(snapshot: snapshot, itemIndex: index)
                      : _emptyListItem(snapshot: snapshot, itemIndex: index)
                  );
                }
              ),
            ),
          )
        );
    }
    assert(true, "It shouldn't reach this point!!");
    return Text("Other error");
  }

  Widget _listItem({AsyncSnapshot<List<Recipe>> snapshot, int itemIndex}) {
    final recipe = snapshot.data[itemIndex];
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: _imageFor(recipe.thumbnail),
      title: Text(recipe.title, maxLines: 1),
      subtitle: Text(recipe.ingredients, maxLines: 2),
      onTap: () {
        _loadURL(recipe.link);
      }
    );
  }

  Widget _emptyListItem({AsyncSnapshot<List<Recipe>> snapshot, int itemIndex}) =>
    ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: _emptyImageWidget,
      title: const Text("Loading"),
      subtitle: const Text("--")
    );

  Widget _imageFor(Uri thumbnailLink) {

    final thumbnailString = thumbnailLink.toString();
    if (thumbnailString.isEmpty) {
      return _emptyImageWidget;
    }

    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/recipe/placeholder.png',
          image: thumbnailString,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 50),
        ),
      )
    );
  }

  Widget get _emptyImageWidget =>
    const CircleAvatar(
      radius: 25,
      backgroundImage: const AssetImage('assets/recipe/placeholder.png')
    );


  // - Network related

  Future<List<Recipe>> _fetchRecipes(RecipeStateNotifier state) async {
    try {

      if (state.page == 1) {
        _recipes.clear();
      }

      final currentPageRecipes = state.page == 1
        ? await widget.recipeUseCase.multiFetch(
          ingredients: state.ingredients,
          query: state.searchQuery,
          pages: [state.page, state.page + 1]
         )
        : await widget.recipeUseCase.fetch(RecipeQuery(
            ingredients: state.ingredients,
            query: state.searchQuery,
            page: state.page
          ));

      _hasMoreRecipes = currentPageRecipes.length >= _pageSize;

      if (state.page == 1) {
        _recipes = currentPageRecipes.toList();
      } else {
        _recipes.addAll(currentPageRecipes.toList());
      }
      _isLoadingFromScroll = false;

      return _recipes;
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  // - Actions

  void _scrollListener(RecipeStateNotifier state) async {

    if (_isLoadingFromScroll) { return; }

    final currentPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final offsetForItem = () => maxScrollExtent / _recipes.length;

    if (currentPosition == maxScrollExtent ||
        currentPosition >= (maxScrollExtent - (_pageSize * 2 * offsetForItem()))) {
      _isLoadingFromScroll = true;
      _increasePage(state);
    }
  }

  void _loadURL(Uri url) async {
    final urlString = url.toString();
    if (urlString.isNotEmpty && await canLaunch(urlString)) {
      await launch(urlString);
    }
  }

  // - State related

  void _increasePage(RecipeStateNotifier state) {
    if (!_hasMoreRecipes) { return; }
    state.page += (state.page == 1 ? 2 : 1);
  }

  void _onReload(RecipeStateNotifier state) {
    _recipes.clear();
    state.resetPage();
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes/Models/Recipe.dart';
import 'package:recipes/Pages/RecipeSearch/Utils/RecipeResultsType.dart';
import 'package:recipes/Pages/RecipeSearch/RecipeStateNotifier.dart';
import 'package:recipes/Services/Recipe/RecipeUseCase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeResultList extends StatefulWidget {
  @override
  _RecipeResultListState createState() => _RecipeResultListState();
}

class _RecipeResultListState extends State<RecipeResultList> {

  static const int _pageSize = 10;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  bool _hasMoreRecipes = true;

  List<Recipe> recipes = [];
  ScrollController scrollController;

  @override
  dispose() {
    super.dispose();
    scrollController.dispose();
  }

  // - Widget building

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeStateNotifier>(
      builder: (context, state, _) => FutureBuilder<List<Recipe>>(
        future: _fetchRecipes(state),
        builder: (context, snapshot) {
          scrollController ??= PrimaryScrollController.of(context)..addListener(() {
            _scrollListener(state);
          });
          if (state.wantToScrollToTop) {
            scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: ElasticOutCurve());
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
        final text = state.searchQuery.isNotEmpty ? "No Results" : "Empty";
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
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              controller: scrollController,
              itemCount: recipes.length + (_hasMoreRecipes ? _pageSize*2 : 0), // (snapshot.data ?? recipes).length,
              itemBuilder: (context, index) {
                final hasRealData = snapshot.hasData && snapshot.data.length > index;
                return Card(
                  child: hasRealData
                    ? _listItem(snapshot: snapshot, itemIndex: index)
                    : _emptyListItem(snapshot: snapshot, itemIndex: index)
                );
              }
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

  Widget _emptyListItem({AsyncSnapshot<List<Recipe>> snapshot, int itemIndex}) {
    final widgets = <Widget>[Text(""), Text("")];
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Column(children: <Widget>[Text(""), ...widgets]),//_emptyImageWidget,
      title: Text("Loading"),
      subtitle: Text("--")
    );
  }

  Widget _imageFor(String thumbnail) {

    if (thumbnail == null || thumbnail.isEmpty) {
      return _emptyImageWidget;
    }

    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/recipe/placeholder.png',
          image: thumbnail,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 50),
        ),
      )
    );
  }

  Widget get _emptyImageWidget {
    return CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/recipe/placeholder.png')
    );
  }

  // - Network related

  Future<List<Recipe>> _fetchRecipes(RecipeStateNotifier state) async {
    try {
      final currentPageRecipes = state.page == 1
          ? await RecipeUseCase.multiFetch(ingredients: state.ingredients, query: state.searchQuery, pages: [state.page, state.page + 1])
          : await RecipeUseCase.fetch(ingredients: state.ingredients, query: state.searchQuery, page: state.page);

      _hasMoreRecipes = currentPageRecipes.length >= _pageSize;

      if (state.page == 1) {
        recipes = currentPageRecipes.toList();
      } else {
        recipes.addAll(currentPageRecipes.toList());
      }

      _isLoading = false;
      return recipes;
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  // - Actions

  void _scrollListener(RecipeStateNotifier state) async {

    if (_isLoading) { return; }

    final currentPosition = scrollController.position.pixels;
    final maxScrollExtent = scrollController.position.maxScrollExtent;
    final offsetForItem = () => maxScrollExtent / recipes.length;

    if (currentPosition == maxScrollExtent ||
        currentPosition >= (maxScrollExtent - (_pageSize * 2 * offsetForItem()))) {
      _isLoading = true;
      _increasePage(state);
    }
  }

  void _loadURL(String url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    }
  }

  // - State related

  void _increasePage(RecipeStateNotifier state) {
    if (!_hasMoreRecipes) { return; }
    state.page += (state.page == 1 ? 2 : 1);
  }

  void _onReload(RecipeStateNotifier state) {
    recipes.clear();
    state.resetPage();
  }
}
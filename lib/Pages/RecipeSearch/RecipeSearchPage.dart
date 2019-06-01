import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:recipes/Pages/RecipeSearch/Widgets/RecipeResultList.dart';
import 'package:recipes/Pages/RecipeSearch/Widgets/RecipeSearchTextField.dart';
import 'package:recipes/Pages/RecipeSearch/RecipeStateNotifier.dart';

class RecipeSearchPage extends StatelessWidget {
  final String title;
  RecipeSearchPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        builder: (context) => RecipeStateNotifier(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[_flexibleAppBar];
          },
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: RecipeSearchTextField()
                ),
                Expanded(
                  child: RecipeResultList(),
                )
              ],
            ),
          )
        )
      ),
    );
  }

  Widget get _flexibleAppBar {
    return SliverAppBar(
      brightness: Brightness.dark,
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _tappableAppBarText,
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://images.britcdn.com/wp-content/uploads/2018/03/most-popular-food-network-recipes.jpg?h=120"
              ),
              fit: BoxFit.cover
            ),
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
            ),
          ),
        )
      ),
    );
  }

  get _tappableAppBarText => Consumer<RecipeStateNotifier>(
    builder: (context, state, _) => GestureDetector(
      onTap: () => state.wantToScrollToTop = true,
      child: Text(this.title,
       style: TextStyle(
         color: Colors.white,
       )
      )
    ),
  );

}

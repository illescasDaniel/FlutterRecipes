import 'package:flutter/material.dart';
import 'package:recipes/Pages/RecipeSearch/RecipeStateNotifier.dart';
import 'package:provider/provider.dart';
import 'package:recipes/Utils/MediaQueryUtils.dart';

class RecipeSearchTextField extends StatelessWidget {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeStateNotifier>(
      builder: (context, state, _) => Container(
        width: MediaQueryUtils.recommendedItemsWidth(context),
        child: TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.search,
          maxLength: 50,
          maxLengthEnforced: true,
          onSubmitted: (text) {
            if (state.searchQuery != text) {
              state.searchQuery = text;
            }
          },
          decoration: InputDecoration(
            filled: true,
            counterText: "",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              color: Colors.grey.shade500,
              icon: const Icon(
                Icons.clear,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _controller.clear();
                  state.resetQuery();
                }
              },
            ),
            hintText: "Search for recipes",
          ),
        ),
      )
    );
  }
}

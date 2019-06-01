import 'package:flutter/material.dart';
import 'package:recipes/Pages/RecipeSearch/RecipeStateNotifier.dart';
import 'package:provider/provider.dart';

class RecipeSearchTextField extends StatelessWidget {
  final _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeStateNotifier>(
      builder: (context, state, _) => TextField(
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
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            color: Colors.grey.shade500,
            icon: Icon(
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
    );
  }
}


/*
"title": "Recipe Puppy",
"version": 0.1,
"href": "http://www.recipepuppy.com/",
"results": [
    {
        "title": "Grilled Italian Chicken Breasts \r\n\t\t\n",
        "href": "http://www.kraftfoods.com/kf/recipes/grilled-italian-chicken-breasts-57825.aspx",
        "ingredients": "garlic, bread crumbs, chicken, butter",
        "thumbnail": "http://img.recipepuppy.com/602998.jpg"
    },
* */
class RecipeResponse {

  final String title;
  final double version;
  final String href;
  final List<RecipeResponseResult> results;

  RecipeResponse({this.title, this.version, this.href, this.results});

  factory RecipeResponse.from({Map<String, dynamic> json}) {
    return RecipeResponse(
        title: json["title"],
        version: json["version"],
        href: json["href"],
        results: RecipeResponseResult.fromResults(json["results"])
    );
  }
}

class RecipeResponseResult {

  final String title;
  final String href;
  final String ingredients;
  final String thumbnail;

  RecipeResponseResult({this.title, this.href, this.ingredients, this.thumbnail});

  factory RecipeResponseResult.from({Map<String, dynamic> json}) {
    return RecipeResponseResult(
        title: json["title"],
        href: json["href"],
        ingredients: json["ingredients"],
        thumbnail: json["thumbnail"]
    );
  }
  static List<RecipeResponseResult> fromResults(List<dynamic> jsonResults) {
    return jsonResults.map((result) => RecipeResponseResult.from(json: result)).toList();
  }
}
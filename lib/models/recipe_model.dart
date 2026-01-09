  class Recipe {
    final int id;
    final String title;
    final String category;
    final String ingredients;
    final String steps;
    final String note;

    Recipe({
      required this.id,
      required this.title,
      required this.category,
      required this.ingredients,
      required this.steps,
      required this.note,
    });

    factory Recipe.fromJson(Map<String, dynamic> json) {
      return Recipe(
        id: json['id'],
        title: json['title'],
        category: json['category'],
        ingredients: json['ingredients'],
        steps: json['steps'],
        note: json['note'] ?? '',
      );
    }
  }

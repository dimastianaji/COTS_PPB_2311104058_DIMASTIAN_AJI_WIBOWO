import 'package:flutter/material.dart';
import '../../services/recipe_service.dart';
import '../../models/recipe_model.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late final Future<Recipe> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = RecipeService.fetchRecipeById(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Resep',
            onPressed: () {
            },
          ),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Error
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Gagal memuat detail resep',
                style: AppText.body,
              ),
            );
          }

          final recipe = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(Space.md),
            child: ListView(
              children: [
                /// Judul
                Text(
                  recipe.title,
                  style: AppText.title,
                ),
                const SizedBox(height: Space.sm),

                /// Kategori
                Text(
                  'Kategori: ${recipe.category}',
                  style: AppText.caption,
                ),

                const SizedBox(height: Space.lg),

                /// Bahan
                Text(
                  'Bahan-bahan',
                  style: AppText.section,
                ),
                const SizedBox(height: Space.sm),
                Text(
                  recipe.ingredients,
                  style: AppText.body,
                ),

                const SizedBox(height: Space.md),

                /// Langkah
                Text(
                  'Langkah-langkah',
                  style: AppText.section,
                ),
                const SizedBox(height: Space.sm),
                Text(
                  recipe.steps,
                  style: AppText.body,
                ),

                /// Catatan (opsional)
                if (recipe.note.isNotEmpty) ...[
                  const SizedBox(height: Space.md),
                  Text(
                    'Catatan',
                    style: AppText.section,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    recipe.note,
                    style: AppText.body,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

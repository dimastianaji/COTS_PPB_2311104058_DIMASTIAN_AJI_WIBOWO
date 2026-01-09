import 'package:flutter/material.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../presentation/widgets/recipe_card.dart';
import '../../presentation/widgets/app_card.dart';
import '../../presentation/pages/recipe_list_page.dart';
import '../../presentation/pages/add_recipe_page.dart';
import '../../services/recipe_service.dart';
import '../../models/recipe_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    _recipesFuture = RecipeService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Masakan'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecipeListPage(),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text('Daftar Resep'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: FutureBuilder<List<Recipe>>(
          future: _recipesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Gagal memuat data', style: AppText.body),
              );
            }

            final recipes = snapshot.data ?? [];

            final total = recipes.length;
            final sarapan =
                recipes.where((r) => r.category == 'Sarapan').length;
            final makan = recipes
                .where((r) =>
                    r.category == 'Makan Siang' ||
                    r.category == 'Makan Malam')
                .length;
            final dessert =
                recipes.where((r) => r.category == 'Dessert').length;

            final latestRecipes = recipes.take(3).toList();

            return ListView(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: Space.md,
                  mainAxisSpacing: Space.md,
                  children: [
                    _StatCard('Total Resep', total.toString()),
                    _StatCard('Sarapan', sarapan.toString()),
                    _StatCard('Makan Siang & Malam', makan.toString()),
                    _StatCard('Dessert', dessert.toString()),
                  ],
                ),

                const SizedBox(height: Space.lg),

                Text('Resep Terbaru', style: AppText.section),
                const SizedBox(height: Space.md),

                if (latestRecipes.isEmpty)
                  const Text('Belum ada resep')
                else
                  ...latestRecipes.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: RecipeCard(recipe: r),
                    ),
                  ),

                const SizedBox(height: Space.lg),

                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RecipeListPage()),
                  ),
                  child: const Text('Daftar Resep'),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Tambah Resep Baru'),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddRecipePage(),
                ),
              );
              setState(_loadRecipes);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Colors.blue,  
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.caption),
          const SizedBox(height: 8),
          Text(value, style: AppText.title),
        ],
      ),
    );
  }
}

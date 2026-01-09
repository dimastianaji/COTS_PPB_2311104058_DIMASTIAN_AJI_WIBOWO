import 'package:flutter/material.dart';
import '../../services/recipe_service.dart';
import '../../design_system/spacing.dart';

class EditRecipePage extends StatefulWidget {
  final int recipeId;

  const EditRecipePage({
    super.key,
    required this.recipeId,
  });

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final ingredients = TextEditingController();
  final steps = TextEditingController();
  final note = TextEditingController();

  String category = 'Sarapan';
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe =
          await RecipeService.fetchRecipeById(widget.recipeId);

      title.text = recipe.title;
      ingredients.text = recipe.ingredients;
      steps.text = recipe.steps;
      note.text = recipe.note;
      category = recipe.category;

      if (mounted) {
        setState(() => loading = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          loading = false;
          error = true;
        });
      }
    }
  }

  @override
  void dispose() {
    title.dispose();
    ingredients.dispose();
    steps.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await RecipeService.updateRecipe(
        id: widget.recipeId,
        body: {
          'title': title.text,
          'category': category,
          'ingredients': ingredients.text,
          'steps': steps.text,
          'note': note.text,
        },
      );

      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan perubahan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Resep')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error
              ? const Center(child: Text('Gagal memuat data resep'))
              : Padding(
                  padding: const EdgeInsets.all(Space.md),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _input(title, 'Judul Resep'),
                        _dropdown(),
                        _input(
                          ingredients,
                          'Bahan-bahan',
                          maxLines: 3,
                        ),
                        _input(
                          steps,
                          'Langkah-langkah',
                          maxLines: 4,
                        ),
                        _input(
                          note,
                          'Catatan',
                          required: false,
                        ),
                        const SizedBox(height: Space.lg),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Simpan Perubahan'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _input(
    TextEditingController c,
    String label, {
    bool required = true,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator:
            required ? (v) => v!.isEmpty ? '$label wajib diisi' : null : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.md),
      child: DropdownButtonFormField<String>(
        value: category,
        items: const [
          'Sarapan',
          'Makan Siang',
          'Makan Malam',
          'Dessert',
        ]
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => category = v!),
        decoration: const InputDecoration(
          labelText: 'Kategori',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/recipe_service.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final ingredients = TextEditingController();
  final steps = TextEditingController();
  final note = TextEditingController();
  String category = 'Sarapan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Resep')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _input(title, 'Judul Resep'),
              _dropdown(),
              _input(ingredients, 'Bahan-bahan'),
              _input(steps, 'Langkah-langkah'),
              _input(note, 'Catatan', required: false),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await RecipeService.addRecipe({
                      'title': title.text,
                      'category': category,
                      'ingredients': ingredients.text,
                      'steps': steps.text,
                      'note': note.text,
                    });
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        validator:
            required ? (v) => v!.isEmpty ? '$label wajib diisi' : null : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: category,
        items: const [
          'Sarapan',
          'Makan Siang',
          'Makan Malam',
          'Dessert'
        ]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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

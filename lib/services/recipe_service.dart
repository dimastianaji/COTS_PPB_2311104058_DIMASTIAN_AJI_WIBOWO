import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeService {
  static final baseUrl = dotenv.env['SUPABASE_URL']!;
  static final apiKey = dotenv.env['SUPABASE_ANON_KEY']!;

  static Map<String, String> get headers => {
        'apikey': apiKey,
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

  static Future<List<Recipe>> fetchRecipes() async {
    final res = await http.get(
      Uri.parse('$baseUrl/rest/v1/recipes?select=*'),
      headers: headers,
    );
    final List data = jsonDecode(res.body);
    return data.map((e) => Recipe.fromJson(e)).toList();
  }

  static Future<void> addRecipe(Map<String, dynamic> body) async {
    await http.post(
      Uri.parse('$baseUrl/rest/v1/recipes'),
      headers: {...headers, 'Prefer': 'return=representation'},
      body: jsonEncode(body),
    );
  }

  static Future<Recipe> fetchRecipeById(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/rest/v1/recipes?id=eq.$id&select=*'),
      headers: headers,
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil detail resep');
    }

    final List data = jsonDecode(res.body);
    return Recipe.fromJson(data.first);
  }

  static Future<void> updateRecipe({
  required int id,
  required Map<String, dynamic> body,
}) async {
  final res = await http.patch(
    Uri.parse('$baseUrl/rest/v1/recipes?id=eq.$id'),
    headers: headers,
    body: jsonEncode(body),
  );

  if (res.statusCode != 204) {
    throw Exception('Gagal memperbarui resep');
  }
}
}

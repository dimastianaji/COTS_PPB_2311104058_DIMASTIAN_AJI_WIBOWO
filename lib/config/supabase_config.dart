class SupabaseConfig {
  static const String baseUrl =
      'https://YOUR_PROJECT_ID.supabase.co/rest/v1/recipes';

  static const String apiKey =
      'YOUR_SUPABASE_ANON_KEY';

  static const Map<String, String> headers = {
    'apikey': apiKey,
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };
}

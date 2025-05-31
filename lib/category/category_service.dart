import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryService {
  static Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://jumlaonline.com/api/categories_and_subcategories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['categories'] ?? [];
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
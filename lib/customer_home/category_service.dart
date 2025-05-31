import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryService {
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final baseUrl = dotenv.env['BASE_URL'];
    final url = Uri.parse('$baseUrl/categories_and_subcategories.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categories = data['categories'] as List;

      return categories.map((cat) {
        return {
          "name": cat["category"],
          "image": cat["img_path"] ?? "assets/png/headphone.png",
          "id": cat["category_id"],
        };
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchService {
  static Future<List<dynamic>> searchByKeyword(String keyword) async {
    final response = await http.get(
      Uri.parse('https://jumlaonline.com/api/search_by_keyword.php?keyword=$keyword'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<dynamic>> getProductsByCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse('https://jumlaonline.com/api/category_products.php?category_id=$categoryId'),
    );

    print('🟦 Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception('Failed to load category products');
    }
  }

  static Future<List<dynamic>> getProductsBySubCategory(String subCategoryId) async {
    final response = await http.get(
      Uri.parse('https://jumlaonline.com/api/subcategory_products.php?sub_category_id=$subCategoryId'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'] ?? [];
    } else {
      throw Exception('Failed to load subcategory products');
    }
  }

}

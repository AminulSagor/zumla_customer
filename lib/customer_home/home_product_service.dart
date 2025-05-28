// services/home_product_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomeProductService {
  static Future<Map<String, List<Map<String, dynamic>>>> fetchHomePageProducts() async {
    final baseUrl = dotenv.env['BASE_URL'];
    final url = Uri.parse('$baseUrl/home_page_products.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['data'];

      return {
        'flash_sales': List<Map<String, dynamic>>.from(result['flash_sales'] ?? []),
        'featured_products': List<Map<String, dynamic>>.from(result['featured_products'] ?? []),
        'best_sales': List<Map<String, dynamic>>.from(result['best_sales'] ?? []),
      };
    } else {
      throw Exception('Failed to load home page products');
    }
  }
}

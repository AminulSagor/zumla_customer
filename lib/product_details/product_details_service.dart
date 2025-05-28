import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailsService {
  static Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final url = 'https://jumlaonline.com/api/product_details.php?product_id=$productId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      if (jsonBody['status'] == 'success') {
        return jsonBody['data'];
      } else {
        throw Exception('Failed to fetch product details: ${jsonBody['status']}');
      }
    } else {
      throw Exception('HTTP error: ${response.statusCode}');
    }
  }
}

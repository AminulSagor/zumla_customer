import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class CartService {
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('https://jumlaonline.com/api/get_cart.php');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonBody['status'] == 'success') {
      return List<Map<String, dynamic>>.from(jsonBody['data']);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to load cart');
    }
  }
}

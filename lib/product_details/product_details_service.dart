import 'dart:convert';
import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

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

  static Future<Map<String, dynamic>> addToCart({
    required String productId,
    required String quantity,
  }) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('https://jumlaonline.com/api/add_to_cart.php');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['status'] == 'success') {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Add to cart failed');
    }
  }

  static Future<String?> getCurrentCartSellerId() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('https://jumlaonline.com/api/get_current_seller_id.php');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['status'] == 'success') {
      final sellerId = responseData['data']['seller_id'];
      return sellerId == "null" ? null : sellerId;
    } else {
      throw Exception('Failed to fetch current seller ID');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSuggestedProductsBySubCategory(String subCategoryId) async {
    final url = Uri.parse('https://jumlaonline.com/api/subcategory_products.php?sub_category_id=$subCategoryId');

    final response = await http.get(url);
    final body = jsonDecode(response.body);



    if (response.statusCode == 200 && body['status'] == 'success') {
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      throw Exception('Failed to fetch suggested products');
    }
  }



}

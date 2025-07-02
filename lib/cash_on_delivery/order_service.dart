import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class OrderService {
  static const String baseUrl = 'https://jumlaonline.com/api/make_order.php';

  static Future<Map<String, dynamic>> makeOrder({
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await TokenStorage.getToken();

    print("📦 Sending order payload:");
    print(jsonEncode({
      "cus_name": name,
      "cus_phone": phone,
      "cus_address": address,
      "payment_method": paymentMethod,
      "items": items,
    }));


    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "cus_name": name,
        "cus_phone": phone,
        "cus_address": address,
        "payment_method": paymentMethod,
        "items": items,
      }),
    );

    print("📥 Response status: ${response.statusCode}");
    print("📥 Response body: ${response.body}");

    final data = jsonDecode(response.body);
    return data;
  }
}

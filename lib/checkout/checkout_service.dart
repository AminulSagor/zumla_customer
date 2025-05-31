import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckoutService {
  static const String baseUrl = 'https://jumlaonline.com/api/get_customer_by_phone.php';

  static Future<Map<String, dynamic>?> getCustomerDetails(String phone, String token) async {
    final url = Uri.parse('$baseUrl?cus_phone=$phone');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      }
    }

    return null;
  }

}

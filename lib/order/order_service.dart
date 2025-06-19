import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class CustomerOrderService {
  static const String _baseUrl = 'https://jumlaonline.com/api/get_cus_orders.php';

  static Future<List<Map<String, dynamic>>> fetchOrdersByStatus(String status) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      print('❌ No token found. Cannot fetch orders.');
      return [];
    }

    final String url = '$_baseUrl?status=${status.toLowerCase()}';

    print('📤 Requesting: $url');
    print('🔐 Token: $token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('📥 Response Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode != 200) return [];

    final body = jsonDecode(response.body);
    if (body['status'] != 'success') return [];

    final List orders = body['orders'];

    return orders.map<Map<String, dynamic>>((order) {
      return {
        'id': order['order_id'],
        'status': order['status'].capitalizeFirst,
        'items': (order['items'] as List).map((item) {
          return {
            'name': item['product_name'],
            'brand': item['brand'],
            'qty': int.tryParse(item['quantity'] ?? '1') ?? 1,
            'price': double.tryParse(item['rate'] ?? '0') ?? 0.0,
            'label': order['status'] == 'delivered' ? 'Review' : null,
            'image': item['image_path'],
          };
        }).toList(),
        'total': double.tryParse(order['total_amount'].toString()) ?? 0.0,
        'delivery_date': order['delivery_date_time'] ?? 'N/A',
        'delivery_time': 'N/A',
      };
    }).toList();
  }
}

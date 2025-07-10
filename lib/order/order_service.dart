import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';
import 'package:get/get.dart';


class CustomerOrderService {
  static const String _baseUrl = 'https://jumlaonline.com/api/get_cus_orders.php';
  static const String _baseUrl_cancel = 'https://jumlaonline.com/api';

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
        'status': order['status'][0].toUpperCase() + order['status'].substring(1),
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


  static Future<bool> cancelOrder(int orderId) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      print('❌ No token found. Cannot cancel order.');
      return false;
    }

    final String url = '$_baseUrl_cancel/cancel_order.php';
    print('📤 Cancelling order ID: $orderId');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'order_id': orderId}),
    );

    print('📥 Response Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode != 200) return false;

    final body = jsonDecode(response.body);
    return body['status'] == 'success';
  }
}

import 'package:get/get.dart';
import '../order_success/order_success_view.dart';
import 'order_service.dart';

class CashOnDeliveryController extends GetxController {
  void confirmOrder() async {
    final args = Get.arguments as Map<String, dynamic>;
    final customer = args['customer'];
    final items = args['items'] as List;
    final total = args['total'];

    // Ensure items are formatted as required by API
    final formattedItems = items.map<Map<String, dynamic>>((item) => {
      "product_id": item['product_id'],
      "quantity": item['quantity'],
      "rate": item['price']?? 10,
    }).toList();

    final response = await OrderService.makeOrder(
      name: customer['name'],
      phone: customer['phone'],
      address: customer['address'],
      paymentMethod: 'cash_on_delivery',
      items: formattedItems,
    );

    if (response['status'] == 'success') {
      Get.to(() => OrderSuccessView());
    } else {
      Get.snackbar("Order Failed", response['message'] ?? "Something went wrong");
    }
  }
}

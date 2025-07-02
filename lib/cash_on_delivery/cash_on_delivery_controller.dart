import 'package:get/get.dart';
import '../order_success/order_success_view.dart';
import 'order_service.dart';

class CashOnDeliveryController extends GetxController {
  var isLoading = false.obs;

  void confirmOrder() async {
    isLoading.value = true;

    final args = Get.arguments as Map<String, dynamic>;
    final customer = args['customer'];
    final items = args['items'] as List;
    final total = args['total'];

    print("🛒 Incoming items: $items");
    print("👤 Customer Info: $customer");

    final formattedItems = items.map<Map<String, dynamic>>((item) => {
      "cart_id": item['cart_id'],
      "quantity": item['quantity'],
      "rate": item['rate'] ?? 10,
    }).toList();


    final response = await OrderService.makeOrder(
      name: customer['name'],
      phone: customer['phone'],
      address: customer['address'],
      paymentMethod: 'cash_on_delivery',
      items: formattedItems,
    );

    isLoading.value = false;

    if (response['status'] == 'success') {
      Get.offAll(() => OrderSuccessView());
    } else {
      Get.snackbar("Order Failed", response['message'] ?? "Something went wrong");
    }
  }
}


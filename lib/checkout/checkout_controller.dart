import 'package:get/get.dart';

import '../storage/token_storage.dart';
import 'checkout_service.dart';

class CheckoutItem {
  final int productId;
  final String image;
  final String title;
  final String brand;
  final double price;
  final int quantity;
  final double delCharge;
  final String? store;

  CheckoutItem({
    required this.productId,
    required this.image,
    required this.title,
    required this.brand,
    required this.price,
    required this.quantity,
    required this.delCharge,
    this.store,
  });
}

class CheckoutController extends GetxController {
  final items = <CheckoutItem>[].obs;
  final customerAddress = RxnString();
  final customerName = RxnString();
  final customerPhone = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadItems();
    _loadCustomerAddress();
  }

  void _loadItems() {
    final List<dynamic> passed = Get.arguments ?? [];

    items.value = passed.map((e) => CheckoutItem(
      productId: e['product_id'] ?? 0,
      image: e['image'] ?? '',
      title: e['title'] ?? '',
      brand: e['brand'] ?? '',
      price: (e['rate'] != null) ? (e['rate'] as num).toDouble() : 0.0,
      quantity: e['quantity'] ?? 1,
      delCharge: (e['del_charge'] != null) ? (e['del_charge'] as num).toDouble() : 0.0,
      store: e['store'],
    )).toList();
  }

  Future<void> _loadCustomerAddress() async {
    final phone = await TokenStorage.getPhoneNumber();
    final token = await TokenStorage.getToken();

    if (phone != null && token != null) {
      final data = await CheckoutService.getCustomerDetails(phone, token);
      if (data != null) {
        customerAddress.value = data['address'];
        customerName.value = data['name'];
        customerPhone.value = data['phone'];
      }
    }
  }

  // ✅ Add these methods so the view can update state
  void updateName(String value) => customerName.value = value;
  void updatePhone(String value) => customerPhone.value = value;
  void updateAddress(String value) => customerAddress.value = value;

  double get subTotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryCharge => items.fold(0, (sum, item) => sum + item.delCharge);
  double get total => subTotal + deliveryCharge;
}

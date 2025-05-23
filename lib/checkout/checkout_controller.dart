import 'package:get/get.dart';

class CheckoutItem {
  final String image;
  final String title;
  final String brand;
  final double price;
  final int quantity;

  CheckoutItem({
    required this.image,
    required this.title,
    required this.brand,
    required this.price,
    required this.quantity,
  });
}

class CheckoutController extends GetxController {
  final items = <CheckoutItem>[
    CheckoutItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      quantity: 1,
    ),
    CheckoutItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      quantity: 1,
    ),
  ].obs;

  double get subTotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryCharge => 10;
  double get total => subTotal + deliveryCharge;
}

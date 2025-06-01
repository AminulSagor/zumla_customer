import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  var selectedMethod = ''.obs;
  var subtotal = 0.0.obs;
  var total = 0.0.obs;

  PaymentMethodController(double totalAmount) {
    subtotal.value = totalAmount;
    total.value = totalAmount; // later you can add shipping/discounts etc.
  }

  void selectMethod(String method) {
    selectedMethod.value = method;
  }
}

import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  var selectedMethod = ''.obs;

  void selectMethod(String method) {
    selectedMethod.value = method;
  }

  double get subtotal => 100;
  double get total => subtotal; // You can add shipping logic later
}

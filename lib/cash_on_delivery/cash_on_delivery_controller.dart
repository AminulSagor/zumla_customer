import 'package:get/get.dart';
import '../order_success/order_success_view.dart';


class CashOnDeliveryController extends GetxController {
  void confirmOrder() {
    // Navigate to success screen
    Get.to(() => OrderSuccessView());
  }
}

import 'package:get/get.dart';

import 'order_service.dart';

class OrderController extends GetxController {
  var selectedTab = 'Pending'.obs;

  var orders = <Map<String, dynamic>>[].obs;

  var showReviewDialog = false.obs;
  var selectedRating = 0.obs;
  var reviewText = ''.obs;
  final selectedReviewItem = Rxn<Map<String, dynamic>>();


  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final data = await CustomerOrderService.fetchOrdersByStatus(selectedTab.value);
    orders.assignAll(data);
  }



  void changeTab(String tab) {
    selectedTab.value = tab;
    fetchOrders();
  }



  void cancelOrder(int index) {
    orders.removeAt(index);
  }

  void openReviewDialog() {
    selectedRating.value = 0;
    reviewText.value = '';
    showReviewDialog.value = true;
  }

  void submitReview() {
    print('⭐ Rating: ${selectedRating.value}');
    print('✍️ Review: ${reviewText.value}');
    showReviewDialog.value = false;
  }
}

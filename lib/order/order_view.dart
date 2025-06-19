import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_controller.dart';

class OrderView extends StatelessWidget {
  final String initialTab;

  OrderView({Key? key, required this.initialTab}) : super(key: key);

  final controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    controller.selectedTab.value = initialTab;
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              _tabBar(),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (_, i) {
                    final order = controller.orders[i];
                    if (order['status'] != controller.selectedTab.value) return const SizedBox();
                    return _orderCard(order, i);
                  },
                ),
              ),
            ],
          ),
          if (controller.showReviewDialog.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: _reviewDialogCard(),
              ),
            ),
        ],
      )),
    );
  }

  Widget _tabBar() {
    final tabs = ['Pending', 'Approved', 'Delivered', 'Rejected'];
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isSelected = controller.selectedTab.value == tab;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(tab, style: const TextStyle(fontSize: 12)), // smaller text
                selected: isSelected,
                onSelected: (_) => controller.changeTab(tab),
                visualDensity: VisualDensity.compact, // optional: tighter chip
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _orderCard(Map<String, dynamic> order, int index) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🧾 Order ID: ${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...order['items'].map<Widget>((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/png/headphone.png',
                    height: 60,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(item['brand']),
                        Text("\$${item['price']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (item['label'] != null)
                        GestureDetector(
                          onTap: () {
                            if (item['label'] == 'Review') {
                              controller.selectedReviewItem.value = item; // pass product info
                              controller.openReviewDialog();
                            }
                          },

                          child: _pillBox(item['label']),
                        ),
                      Text("Qty: ${item['qty']}"),
                    ],
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total Amount (${order['items'].length} Items) \$${order['total']}"),
            ],
          ),
          const SizedBox(height: 8),
          if (order['status'] == 'Pending')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton("Cancel", () => controller.cancelOrder(index)),
              ],
            ),
          if (order['status'] == 'Approved')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _pillBox(order['delivery_date']),
                    const SizedBox(width: 8),
                    _pillBox(order['delivery_time']),
                  ],
                ),
              ],
            ),
          if (order['status'] == 'Delivered')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _pillBox(order['delivery_date']),
                    const SizedBox(width: 8),
                    _pillBox(order['delivery_time']),
                  ],
                ),
              ],
            ),

          if (order['status'] == 'Rejected')
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _pillBox(order['delivery_date']),
                    const SizedBox(width: 8),
                    _pillBox(order['delivery_time']),
                  ],
                ),
              ],
            ),

        ],
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(70, 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: const BorderSide(color: Colors.black),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _reviewDialogCard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are You Satisfied With ${controller.selectedReviewItem.value?['name']}?",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),
              _starRating(),
              const SizedBox(height: 12),
              TextField(
                onChanged: (val) => controller.reviewText.value = val,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  prefixIcon: const Icon(Icons.edit),
                  suffixIcon: const Icon(Icons.image),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => controller.showReviewDialog.value = false,
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: controller.submitReview,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _starRating() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          final selected = controller.selectedRating.value > i;
          return IconButton(
            onPressed: () => controller.selectedRating.value = i + 1,
            icon: Icon(
              selected ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
          );
        }),
      );
    });
  }

  Widget _pillBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

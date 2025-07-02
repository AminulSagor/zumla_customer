import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../checkout/checkout_view.dart';
import 'cart_controller.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';

class CartView extends StatelessWidget {
  final controller = Get.put(CartController());

  void _showQuantityDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return Obx(() {
          final item = controller.cartItems[index];
          return AlertDialog(
            title: const Text("Select Quantity"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (item.quantity > 1) {
                      controller.decrementQuantity(index);
                    }
                  },
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.incrementQuantity(index),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Done"),
              ),
            ],
          );
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(
        selectedIndex: controller.selectedIndex.value,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "My Cart",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16.w),
                const Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10.w),
                const Text(
                  "Sylhet, Bangladesh",
                  style: TextStyle(fontSize: 14, color: Color(0xFF2F6FD8)),
                ),
              ],
            ),
            Obx(
                  () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Select all", style: TextStyle(fontWeight: FontWeight.w500)),
                    Checkbox(
                      value: controller.selectAll.value,
                      onChanged: (value) {
                        if (value != null) controller.toggleSelectAll(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = controller.cartItems;
                if (items.isEmpty) {
                  return const Center(child: Text("No items in cart."));
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                      child: Row(
                        children: [
                          Checkbox(
                            value: item.selected,
                            onChanged: (_) => controller.toggleSelection(index),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(item.brand, style: const TextStyle(color: Colors.grey)),
                                Text("\$${item.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Quantity: ${item.quantity}"),
                                  Transform.translate(
                                    offset: const Offset(0, 4),
                                    child: GestureDetector(
                                      onTap: () => _showQuantityDialog(context, index),
                                      child: const Icon(Icons.unfold_more),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.inStock ? "Available" : "Out Of Stock",
                                style: TextStyle(color: item.inStock ? Colors.green : Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 18, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final isActive = controller.hasSelectedItems;
                    return ElevatedButton(
                      onPressed: isActive
                          ? () {
                        final selectedItems = controller.cartItems
                            .where((item) => item.selected)
                            .map((item) => {
                          'product_id': item.productId,     // ✅ Required
                          'title': item.title,
                          'brand': item.brand,
                          'quantity': item.quantity,        // ✅ Required
                          'rate': item.price,               // ✅ Rename 'price' -> 'rate'
                          'image': item.image,
                          'del_charge': item.delCharge,
                          'store': item.store,
                        })
                            .toList();

                        Get.toNamed('/checkout', arguments: selectedItems);
                      }
                          : null,


                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.blue;
                          }
                          return Colors.blue.shade700;
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.blue.shade700, width: 1),
                          ),
                        ),
                      ),
                      child: Text(
                        controller.selectedItemCount == 0
                            ? "Checkout"
                            : "Checkout (${controller.selectedItemCount})",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

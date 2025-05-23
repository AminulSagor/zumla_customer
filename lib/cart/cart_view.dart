import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';

class CartView extends StatelessWidget {
  final controller = Get.put(CartController());

  void _showQuantityDialog(BuildContext context, int index) {
    final item = controller.cartItems[index];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Quantity"),
          content: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (controller.cartItems[index].quantity > 1) {
                      controller.decrementQuantity(index);
                    }
                  },
                ),
                Text(
                  controller.cartItems[index].quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.incrementQuantity(index),
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(
        selectedIndex: controller.selectedIndex.value,
        onTap: (index) => controller.selectedIndex.value = index,
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
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10.w),
                Text(
                  "Sylhet, Bangladesh",
                  style: TextStyle(fontSize: 14, color: Color(0xFF2F6FD8)),
                ),
                SizedBox(width: 16.w),
                Icon(Icons.delete, color: Colors.grey),
              ],
            ),

            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Select all",
                      style: TextStyle(
                        fontWeight: FontWeight.w500, // your custom color
                      ),
                    ),
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
                final items = controller.cartItems;
                String? currentStore;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    final storeName = item.store ?? '';
                    final isStoreGroupSelected = controller.cartItems
                        .where((e) => e.store == storeName)
                        .every((e) => e.selected);

                    final showStoreHeader = currentStore != item.store;
                    currentStore = item.store;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showStoreHeader)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13.0,
                              vertical: 6,
                            ),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.3, // Adjust as needed
                                  child: Checkbox(
                                    value: isStoreGroupSelected,
                                    onChanged:
                                        (value) => controller
                                            .toggleStoreSelection(item.store),
                                  ),
                                ),

                                const Icon(
                                  Icons.storefront,
                                  color: Color(0xFF2F6FD8),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.store ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: item.selected,
                                onChanged:
                                    (_) => controller.toggleSelection(index),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.image,
                                  height: 65, // Increased height
                                  width:
                                      65, // Optional: Increase width to maintain aspect ratio
                                  fit:
                                      BoxFit
                                          .cover, // Ensures it fills the box if needed
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.brand,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "\$${item.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                          onTap:
                                              () => _showQuantityDialog(
                                                context,
                                                index,
                                              ),
                                          child: const Icon(Icons.unfold_more),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    item.inStock ? "Available" : "Out Of Stock",
                                    style: TextStyle(
                                      color:
                                          item.inStock
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 18,bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final isActive = controller.hasSelectedItems;

                    return ElevatedButton(
                      onPressed: isActive ? controller.checkout : null,
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
                            side: BorderSide(
                              color: Colors.blue.shade700,
                              width: 1,
                            ),
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

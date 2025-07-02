import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../payment_method/payment_method_view.dart';
import 'checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  //final List<Map<String, dynamic>> items;

  //CheckoutView({Key? key, required this.items}) : super(key: key);
  CheckoutView({super.key});


  final controller = Get.put(CheckoutController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Checkout'),
        leading: IconButton(
          icon: Image.asset('assets/png/arrow_back.png', width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/address-info-change', arguments: {
                        'name': controller.customerName.value ?? '',
                        'phone': controller.customerPhone.value ?? '',
                        'address': controller.customerAddress.value ?? '',
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/png/world_map.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 9.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.customerName.value ?? "Loading...",
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  controller.customerPhone.value ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, 14), // 👈 move down by 4 pixels
                          child: const Icon(Icons.arrow_forward_ios, size: 16),
                        ),

                      ],
                    ),
                  ),


                  SizedBox(height: 8.h),
                  Obx(() => Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Home: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: controller.customerAddress.value ?? "Loading address...",
                          ),
                        ],
                      ),
                    ),
                  )),


                ],
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("😃 Wow, Thank you — You’ve picked an amazing product!", style: TextStyle(color: Colors.white)),
            ),
            ...controller.items.map((item) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                    ),
                    SizedBox(width: 12.w),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Qty: ${item.quantity}"),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, color: Color(0xFF2F6FD8)),
                  SizedBox(width: 8),
                  Text(
                    controller.items.isNotEmpty ? controller.items.first.store ?? "Unknown Store" : "Unknown Store",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Delivery Charge", style: TextStyle(fontWeight: FontWeight.w500)),
                  Text("\$${controller.deliveryCharge.toStringAsFixed(2)}"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${controller.total.toStringAsFixed(2)}"),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sub Total(${controller.items.length})", style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text("\$${controller.subTotal.toStringAsFixed(0)}"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("\$${controller.total.toStringAsFixed(0)}"),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Total Amount: ", style: TextStyle(fontSize: 16)),
                  Text(
                    "\$${controller.total.toStringAsFixed(0)}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => PaymentMethodView(), arguments: {
                        'customer': {
                          'name': controller.customerName.value,
                          'phone': controller.customerPhone.value,
                          'address': controller.customerAddress.value,
                        },
                        'items': controller.items.map((item) => {
                          'cart_id': item.productId, // ✅ required
                          'quantity': item.quantity,    // ✅ required
                          'rate': item.price,           // ✅ rename price → rate
                        }).toList(),

                        'total': controller.total,
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      backgroundColor: const Color(0xFF2F6FD8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("place order", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
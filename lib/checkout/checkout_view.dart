import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'checkout_controller.dart';

class CheckoutView extends StatelessWidget {
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/png/world_map.png',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 9.h),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("Fouzia Hussain", style: TextStyle(fontWeight: FontWeight.w600)),
                                  Text("+88016744839", style: TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 16),
                              SizedBox(width: 8.w)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Home: ", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: "Al-Madani Tower, Level-6, Mirboxtula, Sylhet"),
                      ],
                    ),
                  ),
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
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(item.title),
                subtitle: Text(item.brand),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Qty: ${item.quantity}"),
                    Text("\$${item.price}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, color: Color(0xFF2F6FD8)),
                  SizedBox(width: 8),
                  Text("Vibe & Vogue", style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.only(left: 18.w, bottom: 8.h),
              child: const Text("Delivery", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12.w),
                child: const Row(
                  children: [
                    Icon(Icons.local_shipping, size: 20),
                    SizedBox(width: 10),
                    Expanded(child: Text("will get by 22-25")),
                    Text("charge: \$10"),
                  ],
                ),
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
                    onPressed: () {},
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
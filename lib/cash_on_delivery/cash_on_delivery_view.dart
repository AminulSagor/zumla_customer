import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'cash_on_delivery_controller.dart';

class CashOnDeliveryView extends StatelessWidget {
  final controller = Get.put(CashOnDeliveryController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final customer = args['customer'];
    final items = args['items'];
    final total = args['total'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash On Delivery"),
        leading: IconButton(
          icon: Image.asset('assets/png/arrow_back.png', width: 34, height: 34),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/png/cod.png',
                    width: double.infinity,
                    height: 220.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Cash on delivery (COD) lets you pay for your order when it arrives at your doorstep. You don’t need to pay online—just hand over the cash when you get the product. In some cases, you can also pay using your card or a mobile payment app at delivery.\n\nThis option is great if you want to see the item first or if you’re not comfortable with online payments. It’s a secure and trusted way to shop.",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("Confirm Order", style: TextStyle(color: Colors.white)),
              ),
            )),
          )

        ],
      ),
    );
  }
}

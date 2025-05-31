import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../cash_on_delivery/cash_on_delivery_view.dart';
import 'payment_method_controller.dart';

class PaymentMethodView extends StatelessWidget {
  final controller = Get.put(PaymentMethodController());



  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final customer = args['customer'];
    final items = args['items'];
    final total = args['total'];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Select Payment Methods", style: TextStyle(fontSize: 18.sp)),
        leading: IconButton(
          icon: Image.asset('assets/png/arrow_back.png', width: 34, height: 34),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Recommended Methods", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 8.h),
          _buildPaymentOption(
            title: "Credit/Debit Card",
            subtitle: "Credit/Debit, VISA PayPal Cards Are Available",
            iconPath: 'assets/png/card_icon.png',
            value: "card",
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Others Method", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 8.h),
          _buildPaymentOption(
            title: "Cash On Delivery",
            subtitle: "",
            iconPath: 'assets/png/cash_on_delivery.png',
            value: "cod",
          ),
          const Spacer(),
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required String iconPath,
    required String value,
  }) {
    return Obx(() {
      return InkWell(
        onTap: () {
          controller.selectMethod(value);

          if (value == "cod") {
            final args = Get.arguments as Map<String, dynamic>;
            final customer = args['customer'];
            final items = args['items'];
            final total = args['total'];

            Get.to(() => CashOnDeliveryView(), arguments: {
              'customer': customer,
              'items': items,
              'total': total,
            });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.r),
            border: controller.selectedMethod.value == value
                ? Border.all(color: Colors.blue, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Image.asset(iconPath, width: 32.w, height: 32.h),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                    if (subtitle.isNotEmpty)
                      Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp),
            ],
          ),
        ),
      );
    });
  }


  Widget _buildBottomSummary() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sub Total:", style: TextStyle(fontSize: 14.sp)),
              Text("\$${controller.subtotal.toStringAsFixed(0)}", style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              Text("\$${controller.total.toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ],
          ),
        ],
      ),
    );
  }
}

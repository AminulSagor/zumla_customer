import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../checkout/checkout_controller.dart';

class AddressInfoChangeView extends StatelessWidget {
  final controller = Get.find<CheckoutController>();

  void _showEditDialog(BuildContext context, String type, String current) {
    final TextEditingController inputController = TextEditingController(text: current);

    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        type == 'name'
                            ? Icons.person
                            : type == 'phone'
                            ? Icons.phone
                            : Icons.location_on,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (type == 'name') {
                          controller.customerName.value = inputController.text;
                        } else if (type == 'phone') {
                          controller.customerPhone.value = inputController.text;
                        } else {
                          controller.customerAddress.value = inputController.text;
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB7FE),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: const Text("Update", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Information"),
        leading: const BackButton(),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTile(
            icon: Icons.person,
            label: controller.customerName,
            onTap: () => _showEditDialog(context, 'name', controller.customerName.value ?? ''),
          ),
          const Divider(height: 0),
          _buildTile(
            icon: Icons.phone,
            label: controller.customerPhone,
            onTap: () => _showEditDialog(context, 'phone', controller.customerPhone.value ?? ''),
          ),
          const Divider(height: 0),
          _buildTile(
            icon: Icons.location_on,
            label: controller.customerAddress,
            onTap: () => _showEditDialog(context, 'address', controller.customerAddress.value ?? ''),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required RxnString label,
    required VoidCallback onTap,
  }) {
    return Obx(() => ListTile(
      leading: Icon(icon),
      title: Text(label.value ?? ''),
      onTap: onTap,
    ));
  }
}

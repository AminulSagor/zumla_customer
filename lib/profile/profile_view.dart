import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../order/order_view.dart';
import '../settings/settings_view.dart';
import '../widgets/customer_bottom_navigation_widget.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(selectedIndex: 3),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: GestureDetector(
                  onTap: () => Get.to(() => SettingsView()),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Settings", style: TextStyle(fontSize: 14.sp)),
                      SizedBox(width: 4.w),
                      Icon(Icons.settings, size: 20.sp),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8.h),
              // Profile Picture + Settings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              child: ClipOval(
                                child: controller.imageUrl.value.isNotEmpty
                                    ? Image.network(
                                  controller.imageUrl.value,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: Colors.grey),
                                )
                                    : const Icon(Icons.person, size: 50, color: Colors.grey),
                              ),
                            ),


                            Obx(() => controller.isUploading.value
                                ? const CircularProgressIndicator(strokeWidth: 2)
                                : const SizedBox()),

                            Positioned(
                              bottom: 0,
                              right: 10,
                              child: GestureDetector(
                                onTap: controller.uploadImage,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8.h),
                        Text(
                          controller.name.value,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(height: 32.h, thickness: 1),

              // My Order
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text("My Order", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Get.to(() => OrderView(initialTab: "Pending")),

                      child: Row(
                        children: [
                          Text("see all", style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _orderStatusButton("Pending", Icons.list_alt),
                  SizedBox(width: 8.w),
                  _orderStatusButton("Approved", Icons.assignment_turned_in_outlined),
                  SizedBox(width: 8.w),
                  _orderStatusButton("Delivered", Icons.local_shipping_outlined),
                  SizedBox(width: 8.w),
                  _orderStatusButton("Rejected", Icons.cancel_outlined),
                ],
              ),

            ],
          ),
        );
      }),
    );
  }

  Widget _orderStatusButton(String title, IconData icon) {
    return GestureDetector(
      onTap: () => Get.to(() => OrderView(initialTab: title)),
      child: Container(
        width: 70.w, // Optional: fixed width for consistency
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp), // Icon on top
            SizedBox(height: 4.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }



}

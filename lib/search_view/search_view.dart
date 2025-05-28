import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'search_view_controller.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';

class SearchView extends StatelessWidget {
  final controller = Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(
        selectedIndex: 1,
        onTap: (index) {
          // Navigation handling
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        onChanged: controller.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onFilterTap,
                      child: Icon(Icons.tune, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Your search results can go below
            ],
          ),
        ),
      ),
    );
  }
}

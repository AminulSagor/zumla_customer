import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'category_controller.dart';
import 'package:get/get.dart';

class CategoryView extends StatelessWidget {
  final controller = Get.put(CategoryController());

  final Map<String, List<String>> categories = {
    'Electronics Device': ['Headphone', 'Desktop', 'Laptop', 'Mobile'],
    'Skin Care': ['Night Cream', 'Powder', 'Nail Polish', 'Cream'],
    'Travel Essentials': ['Bags', 'Shoes', 'Others Things', 'Suitcase'],
    'Watches': ['Mechanical', 'Smartwatch', 'Rolex', 'Omega'],
    'Toys': ['Teddy Bears', 'Stuffed Animals', 'Abacus', 'Cars'],
    'Gifts': ['Personalized', 'Experiential', 'Practical', 'Luxury'],
    'Clothing': ['Man', 'Woman', 'Kids', 'Infant'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _buildSearchBar(),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView(
                  children: categories.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: entry.value.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(right: 20.w),
                                child: _buildCircleItem(item),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Image.asset(
          'assets/png/arrow_back.png',
          width: 44.w,
          height: 44.h,
        ),

        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleItem(String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundImage: AssetImage('assets/png/headphone.png'),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 12.sp),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

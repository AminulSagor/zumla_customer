import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../search_view/search_view.dart';
import 'category_controller.dart';

class CategoryView extends StatelessWidget {
  final controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            children: [
              _buildSearchBar(context),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() {
                  if (controller.categories.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: controller.categories.length,
                    itemBuilder: (_, index) {
                      final category = controller.categories[index];
                      final subCats = category['sub_categories'] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category['category'] ?? '',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(subCats.length, (subIndex) {
                                final sub = subCats[subIndex];
                                return Padding(
                                  padding: EdgeInsets.only(right: 16.w),
                                  child: _buildCircleItem(
                                    sub['sub_category'] ?? '',
                                    sub['img_path'],
                                    subCategoryId: sub['sub_category_id'].toString(),
                                  ),

                                );
                              }),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset(
            'assets/png/arrow_back.png',
            width: 44.w,
            height: 44.h,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
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

  Widget _buildCircleItem(String label, String? imgUrl, {required String subCategoryId}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SearchView(),  arguments: {'sub_category_id': subCategoryId});
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: imgUrl != null && imgUrl.isNotEmpty
                ? NetworkImage(imgUrl)
                : AssetImage('assets/png/headphone.png') as ImageProvider,
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
      ),
    );
  }

}

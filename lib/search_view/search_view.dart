import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/product_card_section_widget.dart';
import 'search_view_controller.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';

class SearchView extends StatelessWidget {
  final controller = Get.put(SearchViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(selectedIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 0),

          child: Column(
            children: [
              // Search bar
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
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // Brand chips
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (controller.selectedBrand.value != null)
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text("Clear"),
                          selected: false,
                          onSelected: (_) {
                            controller.selectedBrand.value = null;
                          },
                        ),
                      ),
                    ...controller.brands.map((brand) {
                      final isSelected = controller.selectedBrand.value == brand;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(brand),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.selectedBrand.value =
                            isSelected ? null : brand; // toggle
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              )),


              SizedBox(height: 12.h),

              // Product grid
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.products.isEmpty) {
                    return Center(
                      child: Text(
                        "No product found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ProductCardSectionWidget(
                    title: "",
                    items: controller.filteredProducts.cast<Map<String, dynamic>>(),
                    sectionKey: GlobalKey(),
                    scrollController: ScrollController(),
                    showTitle: false,
                    expandGrid: true,
                  );

                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

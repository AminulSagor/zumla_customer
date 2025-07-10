import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';
import 'package:marquee/marquee.dart';
import '../category/category_view.dart';
import '../search_view/search_view.dart';
import '../widgets/product_card_section_widget.dart';
import 'customer_home_controller.dart';

class CustomerHomePage extends StatelessWidget {
  final controller = Get.put(CustomerHomeController());
  final ScrollController scrollController = ScrollController();

  final flashSaleKey = GlobalKey();
  final featuredProductsKey = GlobalKey();
  final bestSalesKey = GlobalKey();
  final bannerSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(selectedIndex: 0),
      body: Obx(() {
        if (controller.isLoadingCategories.value || controller.isLoadingProducts.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(65.w, 55.h),
                    child: Transform.scale(
                      scale: 3.2,
                      child: Image.asset(
                        'assets/png/updated_logo.png',
                        width: 84.w,
                        height: 84.h,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final phoneNumber = '+96890619606';
                          final whatsappUrl = 'https://wa.me/${phoneNumber.replaceAll('+', '')}';
                          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                            await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
                          } else {
                            Get.snackbar('Error', 'Could not launch WhatsApp');
                          }
                        },
                        child: _buildCustomBox(
                          child: Image.asset(
                            'assets/png/whatssap_icon.png',
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              buildSearchBox(
                onChanged: (value) {},
                onFilterTap: () {},
              ),
              SizedBox(height: 16.h),
              Text(
                "All Categories",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 90.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (_, index) {
                    final item = controller.categories[index];
                    final categoryId = item['id'];

                    return GestureDetector(
                      onTap: () {
                        if (categoryId != null) {
                          Get.to(() => SearchView(), arguments: {'category_id': categoryId});
                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundImage: item['image']!.startsWith('http')
                                ? NetworkImage(item['image']!) as ImageProvider
                                : AssetImage(item['image']!),
                          ),
                          SizedBox(height: 6.h),
                          Text(item['name']!, style: TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Image.asset('assets/png/down_arrow.png', width: 8.w, height: 8.h),
              Center(
                child: Transform.translate(
                  offset: Offset(0, -8.h),
                  child: TextButton(
                    onPressed: () => Get.to(() => CategoryView()),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("view all", style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ),
              ),
              KeyedSubtree(
                key: bannerSectionKey,
                child: Container(
                  height: 150.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: controller.sliders.map((imageUrl) {
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1.0,
                          autoPlay: true,
                          height: 160.h,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.r),
                              bottomRight: Radius.circular(16.r),
                            ),
                          ),
                          child: Marquee(
                            text: controller.headline.value.isNotEmpty
                                ? controller.headline.value
                                : 'Welcome to Zumla!',
                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            velocity: 40.0,
                            blankSpace: 40.w,
                            pauseAfterRound: Duration(seconds: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              ProductCardSectionWidget(
                title: "Flash Sale",
                items: controller.flashSale,
                sectionKey: flashSaleKey,
                scrollController: scrollController,
                nextSectionKey: featuredProductsKey,
                previousSectionKey: bannerSectionKey,
              ),
              SizedBox(height: 24.h),
              ProductCardSectionWidget(
                title: "Featured Products",
                items: controller.featuredProducts,
                sectionKey: featuredProductsKey,
                scrollController: scrollController,
                nextSectionKey: bestSalesKey,
                previousSectionKey: flashSaleKey,
              ),
              SizedBox(height: 24.h),
              ProductCardSectionWidget(
                title: "Best Sales",
                items: controller.bestSales,
                sectionKey: bestSalesKey,
                scrollController: scrollController,
                nextSectionKey: null,
                previousSectionKey: featuredProductsKey,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      }),
    );
  }
}

Widget _buildCustomBox({required Widget child}) {
  return Container(
    width: 48.w,
    height: 48.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 20.r,
          offset: Offset(0, 10.h),
        ),
      ],
    ),
    child: Center(child: child),
  );
}

Widget buildSearchBox({
  void Function()? onFilterTap,
  void Function(String)? onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10.r, offset: Offset(0, 4.h)),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Row(
      children: [
        Icon(Icons.search, color: Colors.grey, size: 24.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: "search",
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
        // Add filter icon if needed
      ],
    ),
  );
}

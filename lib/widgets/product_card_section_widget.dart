import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../product_details/product_details_service.dart';
import '../routes.dart';
import '../storage/token_storage.dart';
import 'login_required_dialog_widgets.dart';

class ProductCardSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final GlobalKey sectionKey;
  final ScrollController scrollController;
  final GlobalKey? nextSectionKey;
  final GlobalKey? previousSectionKey;
  final bool showTitle;
  final bool expandGrid;

  const ProductCardSectionWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.sectionKey,
    required this.scrollController,
    this.nextSectionKey,
    this.previousSectionKey,
    this.showTitle = true,
    this.expandGrid = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        final String name = item['product_name']?.toString() ?? 'Unknown';
        final String imagePath = item['image_path']?.toString() ?? '';
        final String price = item['price']?.toString() ?? '0';
        final dynamic discount = item['discount'];
        final dynamic discountPrice = item['discount_price'];

        final bool hasDiscount = discount != null &&
            discountPrice != null &&
            num.tryParse(discountPrice.toString()) != 0;

        final id = item['product_id'];

        return GestureDetector(
          onTap: () {
            if (id != null) {
              Get.toNamed('${AppRoutes.productDetails}?id=$id');
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: imagePath.startsWith('http')
                          ? Image.network(
                        imagePath,
                        height: 114.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/png/headphone.png',
                        height: 114.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Row(
                      children: [
                        if (hasDiscount) ...[
                          Text(
                            "\$${discountPrice.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "\$$price",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else ...[
                          Text(
                            "\$$price",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Plus Button
              Positioned(
                bottom: 12.h,
                right: 8.w,
                child: Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                    onPressed: () async {
                      final token = await TokenStorage.getToken();

                      if (token == null || token.isEmpty) {
                        showLoginRequiredDialog();
                        return;
                      }

                      try {
                        final currentCartSellerId = await ProductDetailsService.getCurrentCartSellerId();
                        final productSellerId = item['seller_id']?.toString() ?? '';

                        Future<void> proceedToAdd() async {
                          final result = await ProductDetailsService.addToCart(
                            productId: id.toString(),
                            quantity: "1",
                            colorId: null,
                            variantId: null,
                          );

                          if (result['status'] == 'success') {
                            Get.snackbar('Success', result['message'] ?? 'Added to cart');
                            Get.toNamed(AppRoutes.cardView);
                          } else {
                            Get.snackbar('Error', result['message'] ?? 'Something went wrong');

                          }
                        }

                        if (currentCartSellerId == null || currentCartSellerId == productSellerId) {
                          await proceedToAdd();
                        } else {
                          final shouldProceed = await Get.dialog<bool>(
                            AlertDialog(
                              title: Text("Replace Cart?"),
                              content: Text(
                                "Your existing cart contains products from another seller. If you continue, they will be removed.",
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Get.back(result: false),
                                ),
                                ElevatedButton(
                                  child: Text("OK"),
                                  onPressed: () => Get.back(result: true),
                                ),
                              ],
                            ),
                          );

                          if (shouldProceed == true) {
                            await proceedToAdd();
                          }
                        }
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    },


                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return KeyedSubtree(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2F6FD8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "see all",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.arrow_forward, size: 16.sp),
                    ],
                  ),
                ),
              ],
            ),
            //SizedBox(height: 12.h),
          ],
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent &&
                    nextSectionKey != null) {
                  Scrollable.ensureVisible(
                    nextSectionKey!.currentContext!,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else if (scrollNotification.metrics.pixels == scrollNotification.metrics.minScrollExtent &&
                    previousSectionKey != null) {
                  Scrollable.ensureVisible(
                    previousSectionKey!.currentContext!,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              }
              return false;
            },
            child: expandGrid
                ? Expanded(child: grid)
                : SizedBox(height: 210.h, child: grid),
          ),
        ],
      ),
    );
  }
}

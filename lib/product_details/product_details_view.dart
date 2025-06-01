import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:zumla_customer/product_details/product_details_service.dart';
import '../cart/cart_view.dart';
import '../routes.dart';
import 'product_details_controller.dart';

class ProductDetailsView extends StatelessWidget {


  ProductDetailsView({Key? key}) : super(key: key);




  Color _getColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.grey; // fallback color
    }
  }



  @override
  Widget build(BuildContext context) {
    final String productId = Get.parameters['id'] ?? '';
    final controller = Get.find<ProductDetailsController>(tag: productId);
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Price:",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Obx(() {
                    final price = double.tryParse(controller.discountPrice.value) ?? 0;
                    final qty = controller.quantity.value;
                    final total = price * qty;
                    return Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }),
                ],

              ),
              Obx(() {
                final isLoading = controller.isAddingToCart.value;

                return ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                    try {
                      controller.isAddingToCart.value = true;

                      final currentCartSellerId = await ProductDetailsService.getCurrentCartSellerId();
                      final productSellerId = controller.sellerId.value;

                      Future<void> proceedToAdd() async {
                        final result = await ProductDetailsService.addToCart(
                          productId: productId,
                          quantity: controller.quantity.value.toString(),
                        );
                        Get.snackbar("Success", result['message'] ?? 'Added to cart');
                        Get.to(() => CartView());
                      }

                      if (currentCartSellerId == null || currentCartSellerId == productSellerId) {
                        await proceedToAdd();
                      } else {
                        final shouldProceed = await Get.dialog<bool>(
                          AlertDialog(
                            title: Text("Replace Cart?"),
                            content: Text("Your existing cart contains products from another seller. If you continue, they will be removed."),
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
                      Get.snackbar("Error", e.toString());
                    } finally {
                      controller.isAddingToCart.value = false;
                    }
                  },
                  icon: isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Obx(() => Text(
                              "${controller.quantity.value}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                  label: Text(
                    isLoading ? "Adding..." : "Add To Cart",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),

            ],
          ),
        ),



      body: SafeArea(
        child: ListView(
          children: [
            // Top image + icons + thumbnails
            Stack(
              children: [
                // Main product image
                Obx(
                      () {
                    final images = controller.images;
                    final index = controller.selectedImageIndex.value;

                    if (images.isEmpty || index >= images.length) {
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Center(
                      child: Image.network(
                        images[index],
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),

                    );
                  },
                ),



                // Back button
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),

                // Favorite icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // child: IconButton(
                    //   icon: const Icon(Icons.favorite_border),
                    //   onPressed: () {},
                    // ),
                  ),
                ),

                // Thumbnails with 4+ indicator
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    final thumbnails = controller.images;
                    final visibleThumbnails = thumbnails.length > 4 ? thumbnails.take(3).toList() : thumbnails;
                    final extraCount = thumbnails.length - 3;


                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: visibleThumbnails.asMap().entries.map((entry) {
                        int index = entry.key;
                        String image = entry.value;

                        bool isExtra = thumbnails.length > 4 && index == 2; // last visible
                        bool isSelected = controller.selectedImageIndex.value == index;

                        return GestureDetector(
                          onTap: () {
                            if (!isExtra) {
                              controller.selectedImageIndex.value = index;
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: image.startsWith('http')
                                    ? Image.network(image, width: 48, height: 48, fit: BoxFit.cover)
                                    : Image.asset(image, width: 48, height: 48, fit: BoxFit.cover),
                              ),
                              if (isExtra)
                                Positioned.fill(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "+$extraCount",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),

                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Obx(() => Text(
                    controller.productName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                          "item: ${controller.model.value}",
                          style: const TextStyle(color: Colors.grey),
                        )),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        final hasDiscount = controller.discount.value.isNotEmpty && controller.discount.value != '0';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "\$${controller.discountPrice.value}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (hasDiscount)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${controller.price.value}",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${controller.discount.value}%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }),

                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            final hasDiscount = controller.discount.value.isNotEmpty;

                            final content = hasDiscount
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 18, color: Colors.amber),
                                    Icon(Icons.star, size: 18, color: Colors.amber),
                                    Icon(Icons.star, size: 18, color: Colors.amber),
                                    Icon(Icons.star, size: 18, color: Colors.amber),
                                    Icon(Icons.star_half, size: 18, color: Colors.amber),
                                  ],
                                ),
                                SizedBox(height: 6), // 👈 Space between stars and text
                                Text(
                                  "4.5 Rating",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                                : Row(
                              children: const [
                                Icon(Icons.star, size: 18, color: Colors.amber),
                                Icon(Icons.star, size: 18, color: Colors.amber),
                                Icon(Icons.star, size: 18, color: Colors.amber),
                                Icon(Icons.star, size: 18, color: Colors.amber),
                                Icon(Icons.star_half, size: 18, color: Colors.amber),
                                SizedBox(width: 6),
                                Text(
                                  "4.5 Rating",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            );

                            return Transform.translate(
                              offset: hasDiscount ? const Offset(0, -12) : Offset.zero,
                              child: content,
                            );
                          }),




                          Spacer(),

                          const Icon(Icons.store, size: 18, color: Colors.blue),
                          const SizedBox(width: 4),
                          Obx(() => Text(
                            controller.storeName.value,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Color section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Color",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Row(
                            children: controller.colors.map((name) {
                              final color = _getColorFromName(name);
                              return _colorOption(name, color);
                            }).toList(),
                          )),

                        ],
                      ),
                      // Right: Availability and Quantity
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() => Text(
                            "Availability: ${int.tryParse(controller.stock.value) == 0 ? "Out of Stock" : "In Stock"}",
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                          )),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                "Quantity: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(
                                    () => DropdownButton<int>(
                                  value: controller.quantity.value,
                                  onChanged: (value) => controller.quantity.value = value!,
                                  items: List.generate(
                                    100,
                                        (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text(
                                        "${i + 1}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  underline: SizedBox.shrink(),
                                  icon: Image.asset(
                                    'assets/png/increase_decrease_icon.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Obx(() => ReadMoreText(
                    controller.description.value,
                    trimLines: 4,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' see more',
                    trimExpandedText: ' see less',
                    style: const TextStyle(color: Colors.black),
                    moreStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                    lessStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  )),
                  const SizedBox(height: 16),
                  const Text(
                    "Suggested Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  Obx(
                    () => SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.suggestedProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final item = controller.suggestedProducts[i];
                          final String name = item['name'] as String;
                          final String image = item['image'] as String;
                          final double price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
                          final String suggestedProductId = item['id'].toString();

                          return GestureDetector(
                            onTap: () {
                              Get.offNamed('${AppRoutes.productDetails}?id=$suggestedProductId');
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 170,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: image.isNotEmpty
                                                ? Image.network(
                                              image,
                                              height: 130,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Image.asset(
                                                'assets/png/customer_home_head.png',
                                                height: 130,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                                : Image.asset(
                                              'assets/png/customer_home_head.png',
                                              height: 130,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),

                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Icon(
                                              Icons.favorite_border,
                                              size: 20,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '\$${price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          SizedBox(width: 6),
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '4.5',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    width: 28,  // smaller circle width
                                    height: 28, // smaller circle height
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.6),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        // add to cart action
                                      },
                                      iconSize: 18, // smaller icon size
                                      padding: EdgeInsets.all(0),
                                      constraints: BoxConstraints(
                                        minHeight: 28,
                                        minWidth: 28,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                      ),
                    )


                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Review",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final reviews = controller.reviews;

                    if (reviews.isEmpty) return const Text("No reviews yet.");

                    return Column(
                      children: reviews.map((review) {
                        final reviewerName = review['reviewer_name'] ?? 'Anonymous';
                        final reviewerProfile = review['reviewer_profile'] ?? '';
                        final reviewedImage = review['reviewed_image'] ?? '';
                        final reviewText = review['review'] ?? '';
                        final rating = review['rating'] ?? '0';
                        final date = '11/12/2024'; // Replace with real date if available

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Reviewer Info Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      reviewerProfile,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 16, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text("$rating Rating"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Text(date, style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.close, size: 18),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Review Text and Image Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text
                                  Expanded(
                                    child: ReadMoreText(
                                      reviewText,
                                      trimLines: 3,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '...see more',
                                      trimExpandedText: ' see less',
                                      style: const TextStyle(color: Colors.black),
                                      moreStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      lessStyle: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Image
                                  if (reviewedImage.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        reviewedImage,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 100),
                ],
              ),
            ), // space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _colorOption(String name, Color color) {
    final String productId = Get.parameters['id'] ?? '';
    final controller = Get.find<ProductDetailsController>(tag: productId);
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedColor.value = name,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  controller.selectedColor.value == name
                      ? Colors.black
                      : Colors.grey,
            ),
          ),
          child: CircleAvatar(backgroundColor: color, radius: 8),
        ),
      ),
    );
  }
}


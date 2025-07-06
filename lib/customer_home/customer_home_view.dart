import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';
import 'package:marquee/marquee.dart';
import '../category/category_view.dart';
import '../product_details/product_details_view.dart';
import '../routes.dart';
import '../search_view/search_view.dart';
import 'customer_home_controller.dart';

class CustomerHomePage extends StatelessWidget {
  final controller = Get.put(CustomerHomeController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(selectedIndex: 0),

      body: Obx(() {
        if (controller.isLoadingCategories.value ||
            controller.isLoadingProducts.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(
                      65,
                      55,
                    ), // 20 pixels to the right, 0 vertically
                    child: Transform.scale(
                      scale: 3.2, // Zoom in
                      child: Image.asset(
                        'assets/png/updated_logo.png',
                        width: 84,
                        height: 84,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final phoneNumber =
                              '+96890619606'; // Replace with your number
                          final whatsappUrl =
                              'https://wa.me/${phoneNumber.replaceAll('+', '')}';
                          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                            await launchUrl(
                              Uri.parse(whatsappUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            Get.snackbar('Error', 'Could not launch WhatsApp');
                          }
                        },
                        child: _buildCustomBox(
                          child: Image.asset(
                            'assets/png/whatssap_icon.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              buildSearchBox(
                onChanged: (value) {
                  // handle text change
                },
                onFilterTap: () {
                  // handle filter button tap
                },
              ),
              const SizedBox(height: 16),

              const Text(
                "All Categories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final item = controller.categories[index];
                    final categoryId = item['id'];

                    return GestureDetector(
                      onTap: () {
                        if (categoryId != null) {
                          Get.to(
                            () => SearchView(),
                            arguments: {'category_id': categoryId},
                          );
                        }
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                item['image']!.startsWith('http')
                                    ? NetworkImage(item['image']!)
                                        as ImageProvider
                                    : AssetImage(item['image']!),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['name']!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Image.asset('assets/png/down_arrow.png', width: 8, height: 8),

              Center(
                child: Transform.translate(
                  offset: const Offset(0, -8),
                  child: TextButton(
                    onPressed: () => Get.to(() => CategoryView()),
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("view all", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),

              //const SizedBox(height: 6),
              Container(
                height: 180,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                        height: 160,
                      ),
                    ),




                    // 🔽 Sliding text at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Marquee(
                          text: controller.headline.value.isNotEmpty
                              ? controller.headline.value
                              : 'Welcome to Zumla!',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          velocity: 40.0,
                          blankSpace: 40,
                          pauseAfterRound: Duration(seconds: 1),
                        )


                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSection("Flash Sale", controller.flashSale),
              const SizedBox(height: 24),
              _buildSection("Featured Products", controller.featuredProducts),
              const SizedBox(height: 24),
              _buildSection("Best Sales", controller.bestSales),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    bool isFlashSale = title == "Flash Sale";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // if (isFlashSale)
            //   // RichText(
            //   //   text: const TextSpan(
            //   //     children: [
            //   //       TextSpan(text: "Closing Time: ", style: TextStyle(color: Colors.black, fontSize: 14)),
            //   //       TextSpan(text: "12 : 00 : 00", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
            //   //     ],
            //   //   ),
            //   // )
            // else
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "see all",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 210, // Scrollable height for each section
          child: GridView.builder(

            padding: EdgeInsets.zero,
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 210 / 220,
            ),
            itemBuilder: (_, index) {
              final item = items[index];
              final String name = item['product_name']?.toString() ?? 'Unknown';
              final String imagePath = item['image_path']?.toString() ?? '';
              final String price = item['price']?.toString() ?? '0';
              final dynamic discount = item['discount'];
              final dynamic discountPrice = item['discount_price'];

// true only if discount is NOT null AND discount_price is greater than 0
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
                            child:
                                imagePath.startsWith('http')
                                    ? Image.network(
                                      imagePath,
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.asset(
                                      'assets/png/headphone.png',
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (hasDiscount) ...[
                            Text(
                              "\$${discountPrice.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "\$$price",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else ...[
                            Text(
                              "\$$price",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                          ],
                        ],
                      ),


                    ],
                  ),

                ),
              );
            },
          ),
        ),
    
      ],
    );
  }
}

Widget _buildCustomBox({required Widget child}) {
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.07),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Center(child: child),
  );
}

Widget _filterChip(String label, {required bool isSelected}) {
  return Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}

Widget buildSearchBox({
  void Function()? onFilterTap,
  void Function(String)? onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
      ],
    ),
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Icon(Icons.search, color: Colors.grey),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: "search",
              border: InputBorder.none,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: onFilterTap,
        //   child: Icon(Icons.tune, color: Colors.black87),
        // ),
      ],
    ),
  );
}

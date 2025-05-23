import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zumla_customer/widgets/customer_bottom_navigation_widget.dart';

import 'customer_home_controller.dart';

class CustomerHomePage extends StatelessWidget {
  final controller = Get.put(CustomerHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomerBottomNavigation(
        selectedIndex: 0,
        onTap: (index) {
          // Handle tab navigation here
        },
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good Morning,", style: TextStyle(fontSize: 18)),
                    Text(
                      "Fouzia",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "📍 Sylhet, Bangladesh",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildIconBox(Icons.search),
                    const SizedBox(width: 12),
                    _buildIconBox(Icons.notifications_none),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // All Categories title
            const Text(
              "All Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Horizontal scrollable categories
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final item = controller.categories[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(item['image']!),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['name']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ),

            //const SizedBox(height: 2),

            // Centered see all
            Center(
              child: Transform.translate(
                offset: const Offset(0, -8), // Move up by 6 pixels (adjust as needed)
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "see all",
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 6),

            Container(
              height: 160,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/png/customer_home_head.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Limited Time!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Get Special Offer",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        //const SizedBox(height: 4),
                        Transform.translate(
                          offset: const Offset(0, -8), // Negative Y moves it up
                          child: Row(
                            children: const [
                              SizedBox(width: 108),
                              Text(
                                "up to",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "40%",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        "Get",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),


            const SizedBox(height: 24),
            _buildSection("Flash Sale", controller.flashSale),
            const SizedBox(height: 24),
            _buildSection("Featured Products", controller.featuredProducts),
            const SizedBox(height: 24),
            _buildSection("Best Sales", controller.bestSales),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    bool isFlashSale = title == "Flash Sale";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + (optional) countdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (isFlashSale)
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Closing Time: ",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    TextSpan(
                      text: "12 : 00 : 00",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (!isFlashSale)
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
            )
          ],
        ),

        const SizedBox(height: 12),

        // FlashSale filters only
        if (isFlashSale)
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip("All", isSelected: false),
                _filterChip("Popular", isSelected: true),
                _filterChip("Latest", isSelected: false),
                _filterChip("Oldest", isSelected: false),
                _filterChip("Headset", isSelected: false),
              ],
            ),
          ),

        if (isFlashSale) const SizedBox(height: 12),

        // Product cards
        SizedBox(
          height: isFlashSale ? 210 : 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final item = items[index];
              return Container(
                width: 170,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item['image'],
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite_border, size: 16),
                          ),
                        ),
                        if (isFlashSale)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.star, size: 12, color: Colors.yellow),
                                SizedBox(width: 2),
                                Text("4.5", style: TextStyle(fontSize: 12, color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "\$${item['price']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isFlashSale)
                        const Text(
                          "\$100",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        if (!isFlashSale)
                          Row(
                            children: const [
                              Icon(Icons.star, size: 12, color: Colors.yellow),
                              SizedBox(width: 2),
                              Text("4.5", style: TextStyle(fontSize: 12, color: Colors.black)),
                            ],
                          ),

                        const Spacer(),
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),


        const SizedBox(height: 12),

        // “see all” underlined with arrow for **all** non-Flash sections,
        // or you could show it always if desired
        if (isFlashSale)
          Align(
          alignment: Alignment.centerRight,
          child: TextButton(
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
        ),
      ],
    );
  }


}

Widget _buildIconBox(IconData icon) {
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
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Center(child: Icon(icon, color: Colors.black)),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zumla_customer/customer_home/customer_home_view.dart';
import 'package:zumla_customer/search_view/search_view.dart';
import 'package:zumla_customer/widgets/tooltip_card_with_arrow_widget.dart';

import '../cart/cart_view.dart';

class CustomerBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const CustomerBottomNavigation({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Get.offAll(() => CustomerHomePage());
        break;
      case 1:
        Get.offAll(() => SearchView());
        break;
      case 2:
      Get.offAll(() => CartView());
        break;
      case 3:
      // Get.offAll(() => ProfileView());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedTopClipper(),
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.home, "Home", 0),
            _navItem(Icons.search, "Search", 1),
            _navItem(Icons.shopping_bag_outlined, "Cart", 2),
            _profileItem(3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.yellow : Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.yellow : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _profileItem(int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('assets/png/headphone.png'),
          ),
          const SizedBox(height: 4),
          Text(
            "Profile",
            style: TextStyle(
              color: isSelected ? Colors.yellow : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

}

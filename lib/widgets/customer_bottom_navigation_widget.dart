import 'package:flutter/material.dart';
import 'package:zumla_customer/widgets/tooltip_card_with_arrow_widget.dart';

class CustomerBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomerBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedTopClipper(),
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.only(top: 12, bottom: 24),
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
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _profileItem(int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('assets/png/headphone.png'), // Replace with your asset
          ),
          SizedBox(height: 4),
          Text("Profile", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}


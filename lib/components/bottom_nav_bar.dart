import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.titled, // Use the titled property
      backgroundColor: Colors.lightBlue, // Dark background color
      activeColor: Colors.white, // Bright color for selected item
      color: Colors.grey, // Color for unselected items
      initialActiveIndex: selectedIndex, // Current selected index
      onTap: onItemTapped, // Handle tap event
      items: const [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.add_circle_outline, title: 'Sell'),
        TabItem(icon: Icons.list_alt, title: 'My Ads'),
        TabItem(icon: Icons.account_circle, title: 'Account'),
      ],
    );
  }
}

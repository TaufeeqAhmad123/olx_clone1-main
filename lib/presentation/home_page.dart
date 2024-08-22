// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:olx_clone1/components/bottom_nav_bar.dart';
import 'package:olx_clone1/components/top_nav_bar.dart';
import 'package:olx_clone1/presentation/account_page.dart';
import 'package:olx_clone1/presentation/my_adds.dart';
import 'package:olx_clone1/presentation/sell_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      const HomeContent(), // Home page content
      const SellPage(), // Sell page content
      const MyAdsPage(), // My Ads page content
      const AccountPage(), // Account page content
    ];

    return Scaffold(
      appBar: const TopNavBar(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: _pages[_selectedIndex], // Show the selected page content
    );
  }
}

// Replace this with actual Home content implementation
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Browse categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all categories
              },
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CategoryWidget(
                icon: Icons.directions_car,
                label: 'Motors',
              ),
              CategoryWidget(
                icon: Icons.apartment,
                label: 'Property',
              ),
              CategoryWidget(
                icon: Icons.smartphone,
                label: 'Mobiles',
              ),
              CategoryWidget(
                icon: Icons.directions_bike,
                label: 'Vehicles',
              ),
              CategoryWidget(
                icon: Icons.home,
                label: 'Property for Sale',
              ),
              CategoryWidget(
                icon: Icons.home_work,
                label: 'Property for Rent',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Mobile Phones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // List of items (Placeholder)
        const ItemWidget(
          imageUrl: 'https://via.placeholder.com/150',
          title: 'Samsung Galaxy C7 3/32GB',
          location: 'Meherban Colony, Islamabad',
          price: 'Rs 25,000',
        ),
        const ItemWidget(
          imageUrl: 'https://via.placeholder.com/150',
          title: 'iPhone 13 Pro JV',
          location: 'Meherban Colony, Islamabad',
          price: 'Rs 150,000',
        ),
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryWidget({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String price;

  const ItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(imageUrl),
        title: Text(title),
        subtitle: Text(location),
        trailing: Text(price),
        onTap: () {
          // Handle item tap
        },
      ),
    );
  }
}

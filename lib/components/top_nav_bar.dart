import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const TopNavBar({super.key}) : preferredSize = const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // OLX logo
          Row(
            children: [
              Image.asset('assets/logo.png',
                  height: 40), // Replace with your logo asset
              const SizedBox(width: 8),
              const Text(
                'OLX',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Location dropdown
          DropdownButton<String>(
            value: 'Meherban Colony, Islamabad',
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            underline: Container(height: 0),
            onChanged: (String? newValue) {
              // Handle location change
            },
            items: <String>[
              'Meherban Colony, Islamabad',
              'Location 2',
              'Location 3'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        // Search bar
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'What are you looking for?',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }
}

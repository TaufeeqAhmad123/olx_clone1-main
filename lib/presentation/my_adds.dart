import 'package:flutter/material.dart';

class MyAdsPage extends StatelessWidget {
  const MyAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for user's ads. In a real app, this data would come from a database.
    final List<Map<String, String>> myAds = [
      {
        'title': 'Samsung Galaxy C7 3/32GB',
        'price': 'Rs 25,000',
        'location': 'Meherban Colony, Islamabad',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'title': 'iPhone 13 Pro JV',
        'price': 'Rs 150,000',
        'location': 'Meherban Colony, Islamabad',
        'imageUrl': 'https://via.placeholder.com/150',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
      ),
      body: ListView.builder(
        itemCount: myAds.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.network(myAds[index]['imageUrl']!),
              title: Text(myAds[index]['title']!),
              subtitle: Text(
                  '${myAds[index]['location']} • ${myAds[index]['price']}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle actions like edit or delete
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
              onTap: () {
                // Handle ad click
              },
            ),
          );
        },
      ),
    );
  }
}

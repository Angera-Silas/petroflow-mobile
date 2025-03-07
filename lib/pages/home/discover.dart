import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorials = [
      {"title": "How to Add Sales", "icon": Icons.play_circle_fill},
      {"title": "Managing Inventory", "icon": Icons.play_circle_fill},
      {"title": "Generating Reports", "icon": Icons.play_circle_fill},
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Discover",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tutorials.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(tutorials[index]["icon"] as IconData),
              title: Text(tutorials[index]["title"] as String),
              onTap: () {
                // Play tutorial video or open details
              },
            );
          },
        ),
      ),
    );
  }
}

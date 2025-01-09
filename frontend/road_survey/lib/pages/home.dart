import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> options = [
    {"title": "Punjab Mandi Board", "image": "assets/images/mandi_board.png"},
    {"title": "NHAI", "image": "assets/images/nhai.png"},
    {"title": "Delhi", "image": "assets/images/delhi.png"},
    {"title": "Dev", "image": "assets/images/dev.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo
              height: 40,
            ),
            const SizedBox(height: 5),
            const Text(
              'ROAD ATHENA',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return GestureDetector(
              onTap: () {
                // Add navigation logic here
                print('Tapped on ${option["title"]}');
                // Navigate to detail page when a list item is tapped
                Navigator.pushNamed(context, '/detail');
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      option['image']!,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    option['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

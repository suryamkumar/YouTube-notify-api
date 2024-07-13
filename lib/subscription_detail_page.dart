import 'package:flutter/material.dart';

class SubscriptionDetailPage extends StatelessWidget {
  final dynamic subscription; // Subscription data

  SubscriptionDetailPage({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subscription['snippet']['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(subscription['snippet']['thumbnails']['high']['url']),
            SizedBox(height: 16.0),
            Text(
              subscription['snippet']['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(subscription['snippet']['description']),
          ],
        ),
      ),
    );
  }
}

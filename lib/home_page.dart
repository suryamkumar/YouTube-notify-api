import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:notifybear_api_test/profile_page.dart';
import 'dart:convert';

import 'package:notifybear_api_test/subscription_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance
  List<dynamic> subscriptions = []; // List to store subscriptions
  List<dynamic> filteredSubscriptions = []; // List to store filtered subscriptions
  TextEditingController _searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions(); // Fetch subscriptions on page load
    _searchController.addListener(_filterSubscriptions); // Add listener to filter subscriptions
  }

  // Function to filter subscriptions based on search query
  void _filterSubscriptions() {
    setState(() {
      filteredSubscriptions = subscriptions
          .where((subscription) => subscription['snippet']['title']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  // Function to fetch YouTube subscriptions
  Future<void> _fetchSubscriptions() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final String? token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          subscriptions = jsonDecode(response.body)['items'];
          filteredSubscriptions = subscriptions;
        });
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Subscriptions'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: _auth.currentUser!),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSubscriptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredSubscriptions[index]['snippet']['title']),
                  subtitle: Text(filteredSubscriptions[index]['snippet']['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionDetailPage(subscription: filteredSubscriptions[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

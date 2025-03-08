import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersProvider with ChangeNotifier {
  List<Map<String, dynamic>> users = [];

  UsersProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final user = FirebaseAuth.instance.currentUser; // Get the logged-in user

    users = [
      {
        "uid": "EkWWVFU8qARRMQNcnDe0uFghzhx1",
        "email": "dhokvedant43@gmail.com",
      },
      // {
      //   "uid": "JH67GHD8QkYFRT28kLpZdXmh2",
      //   "email": "staticuser2@example.com",
      // },
    ];

    if (user != null) {
      users.add({
        "uid": user.uid,
        "email": user.email ?? 'No Email',
      });
    }

    notifyListeners();
  }
}

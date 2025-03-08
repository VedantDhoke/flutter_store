import 'package:ecommerce_admin_tut/provider/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_admin_tut/widgets/page_header.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Column(
        children: [
          PageHeader(text: 'Users'),
          Expanded(
            child: ListView.builder(
              itemCount: usersProvider.users.length,
              itemBuilder: (context, index) {
                final userData = usersProvider.users[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(userData['email'] ?? 'No Email'),
                    subtitle: Text("UID: ${userData['uid'] ?? 'No UID'}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

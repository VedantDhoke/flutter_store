import 'package:ecommerce_admin_tut/rounting/route_names.dart';
import 'package:ecommerce_admin_tut/rounting/router.dart';
import 'package:ecommerce_admin_tut/services/navigation_service.dart';
import 'package:ecommerce_admin_tut/widgets/side_menu/side_menu.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import 'package:ecommerce_admin_tut/widgets/navbar/navigation_bar.dart'
    as custom_nav;

class LayoutTemplate extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      drawer: Container(
        color: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("abc@gmail.com"),
              accountName: Text("Santos Enoque"),
            ),
            ListTile(
              title: Text("Lessons"),
              leading: Icon(Icons.book),
            )
          ],
        ),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Column(
              children: [
                // Replacing custom NavigationBar with Flutter's NavigationBar
                NavigationBar(
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.book),
                      label: 'Lessons',
                    ),
                    // Add more destinations as required
                  ],
                  onDestinationSelected: (index) {
                    // Handle destination selection
                  },
                ),
                Expanded(
                  child: Navigator(
                    key: locator<NavigationService>().navigatorKey,
                    onGenerateRoute: generateRoute,
                    initialRoute: HomeRoute,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

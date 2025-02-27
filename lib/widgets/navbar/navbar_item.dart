import 'package:ecommerce_admin_tut/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final String navigationPath;
  const NavBarItem({required this.title,  required this.navigationPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(navigationPath);
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
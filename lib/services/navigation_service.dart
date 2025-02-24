import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(String routeName) async {
    // Adding null check with '!' to ensure 'currentState' is not null
    await navigatorKey.currentState?.pushNamed(routeName);
  }

  Future<dynamic> globalNavigateTo(String routeName, BuildContext context) {
    return Navigator.of(context).pushNamed(routeName);
  }

  void goBack() {
    // Adding null check with '!' to ensure 'currentState' is not null
    navigatorKey.currentState?.pop();
  }
}

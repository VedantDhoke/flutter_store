import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardProvider with ChangeNotifier {
  int totalProducts = 0;
  int totalOrders = 0;
  double totalRevenue = 0.0;

  DashboardProvider() {
    fetchDashboardData(); // Fetch data on initialization
  }

  Future<void> fetchDashboardData() async {
    try {
      // Fetch total products
      final productsSnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      totalProducts = productsSnapshot.docs.length;

      // Fetch total orders & revenue
      final ordersSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      totalOrders = ordersSnapshot.docs.length;

      double revenue = 0.0;
      for (var order in ordersSnapshot.docs) {
        revenue +=
            order['total_amount']; // Assuming each order has an "amount" field
      }
      totalRevenue = revenue;

      notifyListeners(); // Update UI
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
  }
}

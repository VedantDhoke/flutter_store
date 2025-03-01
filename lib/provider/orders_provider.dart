import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrdersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  Future<void> fetchOrders() async {
    try {
      FirebaseFirestore.instance.collection('orders').snapshots().listen(
        (snapshot) {
          _orders = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "id": doc.id,
              "customer_name": data["customer_name"] ?? "Unknown Customer",
              "total_amount": data["total_amount"] ?? 0.0,
              "status": data["status"] ?? "Pending",
              "order_date": data["order_date"] ?? Timestamp.now(),
            };
          }).toList();
          notifyListeners();
        },
      );
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching orders: $error");
      }
    }
  }

  Future<void> addOrder(
      String customerName, double totalAmount, String status) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        "customer_name": customerName,
        "total_amount": totalAmount,
        "status": status,
        "order_date": Timestamp.now(),
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error adding order: $error");
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      notifyListeners(); // Notify listeners to update the UI
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting order: $error");
      }
    }
  }
}

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
              ...data, // This will include all fields, including the 'products' array
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

  Future<void> placeMultiProductOrderAndReduceStock({
    required String customerName,
    required double totalAmount,
    required String status,
    required List<Map<String, dynamic>>
        products, // Each map = {product_id, quantity}
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Step 1: Check and reduce stock for each product
      WriteBatch batch = firestore.batch();

      for (var product in products) {
        String productId = product['product_id'];
        int orderedQuantity = product['quantity'];

        DocumentReference productRef =
            firestore.collection('products').doc(productId);
        DocumentSnapshot productDoc = await productRef.get();

        if (!productDoc.exists || productDoc['count'] == null) {
          throw Exception("Product not found or count missing for $productId");
        }

        int currentCount = productDoc['count'];

        if (currentCount < orderedQuantity) {
          throw Exception("Not enough stock for product $productId");
        }

        batch.update(productRef, {
          'count': currentCount - orderedQuantity,
        });
      }

      // Step 2: Add the order
      await batch.commit(); // Commit stock updates

      await firestore.collection('orders').add({
        "customer_name": customerName,
        "total_amount": totalAmount,
        "status": status,
        "order_date": Timestamp.now(),
        "products": products,
      });

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Error placing multi-product order: $error");
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting order: $error");
      }
    }
  }
}

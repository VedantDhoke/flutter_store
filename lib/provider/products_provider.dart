import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  Future<void> fetchProducts() async {
    try {
      FirebaseFirestore.instance.collection('products').snapshots().listen(
        (snapshot) {
          _products = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "id": doc.id,
              "name": data["name"] ?? "Unknown Product",
              "price": data["price"] ?? 0.0,
              "count": data["count"] ?? 0, // ✅ include count
              "timestamp": data["timestamp"] ?? Timestamp.now(),
            };
          }).toList();
          notifyListeners();
        },
      );
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching products: $error");
      }
    }
  }

  Future<void> addProduct(String name, double price, int count) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        "name": name,
        "price": price,
        "count": count, // ✅ store count
        "timestamp": Timestamp.now(),
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error adding product: $error");
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
    } catch (error) {
      if (kDebugMode) {
        print("Error deleting product: $error");
      }
    }
  }
}

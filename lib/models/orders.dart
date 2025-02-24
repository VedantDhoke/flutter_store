import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";

  late String _id;
  late String _description;
  late String _userId;
  late String _status;
  late int _createdAt;
  late int _total;

  // Getters
  String get id => _id;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  int get total => _total;
  int get createdAt => _createdAt;

  // Public variable
  late List cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>?; // Ensure type safety

    _id = data?[ID] ?? "";
    _description = data?[DESCRIPTION] ?? "";
    _total = data?[TOTAL] ?? 0;
    _status = data?[STATUS] ?? "";
    _userId = data?[USER_ID] ?? "";
    _createdAt = data?[CREATED_AT] ?? 0;
    cart = data?[CART] ?? [];
  }
}

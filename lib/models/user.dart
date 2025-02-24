import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";

  late String _id; // Use late to declare non-nullable fields
  late String _name;
  late String _email;

  // Getters
  String get name => _name;
  String get email => _email;
  String get id => _id;

  // Constructor for creating a UserModel from a Firestore snapshot
  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    // Use 'get' to safely retrieve data from the snapshot and handle potential null values
    _name = snapshot.get(NAME) ??
        'Unknown'; // Provide a default value if 'name' is null
    _email = snapshot.get(EMAIL) ??
        'Unknown'; // Provide a default value if 'email' is null
    _id = snapshot.get(ID) ?? ''; // Provide a default value if 'id' is null
  }
}

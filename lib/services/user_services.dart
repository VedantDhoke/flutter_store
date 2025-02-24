import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_tut/models/user.dart';

class UserServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new user document
  Future createUser(
      {required String id, required String name, required String email}) async {
    try {
      await _db.collection('users').doc(id).set({
        UserModel.ID: id,
        UserModel.NAME: name,
        UserModel.EMAIL: email,
      });
    } catch (e) {
      print(e);
    }
  }

  // Get user data by ID
  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(id).get();
      return UserModel.fromSnapshot(snapshot);
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }

  // Update user data
  Future updateUserData(Map<String, dynamic> data) async {
    try {
      String userId = data[UserModel.ID];
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      print(e);
    }
  }
}

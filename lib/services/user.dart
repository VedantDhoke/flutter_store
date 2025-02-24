// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_tut/helpers/costants.dart';
import 'package:ecommerce_admin_tut/models/user.dart';

class UserServices {
  String collection = "admins";

  void createUser({
    required String id,
    required String name,
    required String email,
  }) {
    firebaseFiretore.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "email": email,
    });
  }

  void updateUserData(Map<String, dynamic> values) {
    firebaseFiretore.collection(collection).doc(values['id']).update(values);
  }

  Future<UserModel> getUserById(String id) =>
      firebaseFiretore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}

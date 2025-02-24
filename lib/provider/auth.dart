import 'dart:async';
import 'package:ecommerce_admin_tut/helpers/costants.dart';
import 'package:ecommerce_admin_tut/models/user.dart';
import 'package:ecommerce_admin_tut/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_admin_tut/services/navigation_service.dart';
import 'package:ecommerce_admin_tut/locator.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  User? _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  UserModel? _userModel;

  Status get status => _status;
  User? get user => _user;
  UserModel? get userModel => _userModel;

  final formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();

  AuthProvider.initialize() {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("id");

    if (userId != null) {
      _user = FirebaseAuth.instance.currentUser;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _status = Status.Authenticating;
      notifyListeners();

      UserCredential result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      _user = result.user;

      if (_user != null) {
        await prefs.setString("id", _user!.uid);
        return true;
      }
      return false;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print("Login Error: ${e.toString()}");

      // Show Firebase error in a Snackbar
      ScaffoldMessenger.of(
              locator<NavigationService>().navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      _user = result.user;
      if (_user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", _user!.uid);
        _userServices.createUser(
          id: _user!.uid,
          name: name.text.trim(),
          email: email.text.trim(),
        );
        _status = Status.Authenticated;
      }
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print("Sign-up error: ${e.toString()}");
      return false;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  void clearController() {
    name.clear();
    password.clear();
    email.clear();
  }

  Future<void> reloadUserModel() async {
    if (_user != null) {
      _userModel = await _userServices.getUserById(_user!.uid);
      notifyListeners();
    }
  }

  void _onStateChanged(User? firebaseUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user = firebaseUser;

    if (_user != null) {
      await prefs.setString("id", _user!.uid);
      _userModel = await _userServices.getUserById(_user!.uid);
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }
}

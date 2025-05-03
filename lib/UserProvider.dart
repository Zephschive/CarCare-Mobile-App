
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String? _fullname;
  String? _email;
  String? avatarPath;
  bool _isLoading = false;
  

  String? get fullname => _fullname;
  String? get email => _email;
  bool get isLoading => _isLoading;

  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final userEmail = currentUser.email;
      if (userEmail == null) return;

      _email = userEmail;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _fullname = snapshot.docs.first['fullname'];
        avatarPath = snapshot.docs.first['avatarPath'];
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUserData() {
    _fullname = null;
    _email = null;
    notifyListeners();
  }
}

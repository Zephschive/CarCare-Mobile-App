import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String? _fullname;
  String? _email;
  String? avatarPath;
  bool _isLoading = false;

  String? get fullname => _fullname;
  String? get email    => _email;
  bool    get isLoading => _isLoading;

  UserProvider() {
    // Whenever auth state changes, clear or fetch
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // signed out
        clearUserData();
      } else {
        // signed in (or switched accounts)
        fetchUserDetails();
      }
    });
  }

  Future<void> fetchUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Always overwrite email & avatarPath
      _email = currentUser.email;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        _fullname   = data['fullname']   as String?;
        avatarPath  = data['avatarPath'] as String?;
      } else {
        _fullname = null;
        avatarPath = null;
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUserData() {
    _fullname   = null;
    _email      = null;
    avatarPath  = null;
    _isLoading  = false;
    notifyListeners();
  }
}

import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Maintenance_tips_page.dart';
import 'package:carcare/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({super.key});

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  int selectedIndex = 0; // Default screen index (Dashboard)

  // List of available screens
  final List<Widget> pages = [
    HomePage(),
    MaintenanceTipsPage(),
  ];

  void onItemSelected(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is not logged in, redirect to LoginPage
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            // Navigate to login and remove all previous routes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            });
            // While redirecting, return empty container
            return const Scaffold(body: SizedBox.shrink());
          }
        }

        // Otherwise show main navigator
        return Scaffold(
          drawer: SideMenuDrawer(selectedIndex: selectedIndex),
          body: pages[selectedIndex],
        
        );
      },
    );
  }
}

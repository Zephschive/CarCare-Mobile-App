import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Maintenance_tips_page.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({super.key});

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  int selectedIndex = 0; // Default screen index (Dashboard)

  // List of available screens
  final List<Widget> pages = [
            HomePage(Theme: false,),
            MaintenanceTipsPage()
  ];


  void onItemSelected(int index) {
    print(" /// Navigating to index: $index");
    setState(() {
      selectedIndex = index;
    });
     print(" ///// Navigating to index: $selectedIndex");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      drawer: SideMenuDrawer(
        selectedIndex: selectedIndex,
      ),
      body:pages[selectedIndex],
    );
  }
}

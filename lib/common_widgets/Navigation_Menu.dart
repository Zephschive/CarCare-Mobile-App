import 'package:carcare/pages/SupportPage.dart';
import 'package:flutter/material.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Maintenance_tips_page.dart';


class SideMenuDrawer extends StatelessWidget {
  final int selectedIndex;

  const SideMenuDrawer({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Profile Section
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text("Alex Hkeuiao"),
            accountEmail: const Text("License Plate: 38192791972"),
            currentAccountPicture: const Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/img/Avatar.png"),
              ),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(context, Icons.home, "Dashboard", 0, HomePage()),
                _buildDrawerItem(context, Icons.build, "Maintenance Tips", 1, MaintenanceTipsPage()),
                _buildDrawerItem(context, Icons.car_repair, "Towing Service", 2, MaintenanceTipsPage()),
                _buildDrawerItem(context, Icons.notifications, "Service Reminders", 3, HomePage()),
                _buildDrawerItem(context, Icons.description, "Documents", 4, HomePage()),
                _buildDrawerItem(context, Icons.support, "Support", 5, SupportCenterPage()),
                _buildDrawerItem(context, Icons.settings, "Settings", 6, MaintenanceTipsPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget with Navigation
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index, Widget page) {
    bool isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
      tileColor: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

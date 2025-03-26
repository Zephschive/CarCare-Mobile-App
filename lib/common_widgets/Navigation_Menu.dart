import 'package:flutter/material.dart';

class SideMenuDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenuDrawer({super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  _SideMenuDrawerState createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
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
            currentAccountPicture: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: const CircleAvatar(
                radius: 40, // Make it slightly larger
                backgroundImage: AssetImage("assets/profile.jpg"), // Replace with actual profile image
              ),
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(Icons.home, "Dashboard", 0),
                _buildDrawerItem(Icons.car_repair, "Towing Service", 1),
                _buildDrawerItem(Icons.build, "Maintenance Tips", 2),
                _buildDrawerItem(Icons.notifications, "Service Reminders", 3),
                _buildDrawerItem(Icons.description, "Documents", 4),
                _buildDrawerItem(Icons.support, "Support", 5),
                _buildDrawerItem(Icons.settings, "Settings", 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget with Active Highlighting
  Widget _buildDrawerItem(IconData icon, String title, int index) {
    bool isSelected = widget.selectedIndex == index;

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
      tileColor: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Highlight active
      onTap: () {
        widget.onItemSelected(index);
        Navigator.pop(context); // Close the drawer after selection
      },
    );
  }
}

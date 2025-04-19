import 'package:carcare/pages/Documentspage.dart';
import 'package:carcare/pages/ReminderPage.dart';
import 'package:carcare/pages/Settingspage.dart';
import 'package:carcare/pages/SupportPage.dart';
import 'package:carcare/pages/TowingRequestpage.dart';
import 'package:flutter/material.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Maintenance_tips_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:provider/provider.dart';


class SideMenuDrawer extends StatelessWidget {
  final int selectedIndex;

  const SideMenuDrawer({super.key, required this.selectedIndex});


  
  @override
  Widget build(BuildContext context) {
    
  bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
 
    return Drawer(
      child: Column(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                      colors: [  Colors.blue , Colors.blueAccent ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
            ),
            child: Column(
              children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/img/Avatar.png"),
                    ),
                    SizedBox(height: 20,),
                    Text("ALEX Hdndfjaddan", style: GoogleFonts.abel(
                      color: Colors.white,
                    ),),
                  
                     Text("ALEX Hdndfjaddan", style: GoogleFonts.abel(
                      color: Colors.white,
                    ),),
              

                 Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

              }, icon: Icon(isDark ? Icons.sunny : Icons.nightlight))
            ],)
              ],
            ),
          ),
         
          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(context, Icons.home, "Dashboard", 0, HomePage()),
                _buildDrawerItem(context, Icons.build, "Maintenance Tips", 1, MaintenanceTipsPage()),
                _buildDrawerItem(context, Icons.car_repair, "Towing Service", 2, TowingRequestPage()),
                _buildDrawerItem(context, Icons.notifications, "Service Reminders", 3, ReminderPage()),
                _buildDrawerItem(context, Icons.description, "Documents", 4, Documentspage()),
                _buildDrawerItem(context, Icons.support, "Support", 5, SupportCenterPage()),
                _buildDrawerItem(context, Icons.settings, "Settings", 6, ProfileSettingsPage()),
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

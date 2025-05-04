import 'package:carcare/UserProvider.dart';
import 'package:carcare/pages/Documentspage.dart';
import 'package:carcare/pages/ReminderPage.dart';
import 'package:carcare/pages/Settingspage.dart';
import 'package:carcare/pages/SupportPage.dart';
import 'package:carcare/pages/TowingRequestpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Maintenance_tips_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:provider/provider.dart';



class SideMenuDrawer extends StatefulWidget {
  final int selectedIndex;

  

  SideMenuDrawer({super.key, required this.selectedIndex});

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  static String? _cachedFullname;
  String? _fullname;


@override
void initState() {
  super.initState();

   Future.microtask(() {
    Provider.of<UserProvider>(context, listen: false).fetchUserDetails();
   
  });
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<UserProvider>(context, listen: false);
  });
}

  final _currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 



  @override
  Widget build(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);
  bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

      ImageProvider avatarImage;
    if (userProvider.avatarPath != null && userProvider.avatarPath!.isNotEmpty) {
      // if it's a URL
    

        // or if it's an asset identifier
        avatarImage = AssetImage(userProvider.avatarPath!);
      
    } else {
      // fallback
      avatarImage = const AssetImage("assets/img/Avatar.png");
    }
 
    return Drawer(
      backgroundColor: isDark ?Colors.white : Colors.black87,
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
                      backgroundImage: avatarImage,
                    ),
                    SizedBox(height: 40,),
                    Text(" ${userProvider.fullname ?? "(Loading)"}", style: GoogleFonts.abel(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),),
                  
                  SizedBox(height: 25,),
                     Text(" ${userProvider.email?? "(Loading)"}", style: GoogleFonts.abel(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                    ),),
              

                 Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

              }, icon: Icon(isDark ? Icons.sunny : Icons.nightlight),
                color: isDark ? Colors.white : Colors.black87,
              )
            ],)
              ],
            ),
          ),
         
          // Drawer Items
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(context, Icons.home, "Dashboard", 0, HomePage(), isDark),
                _buildDrawerItem(context, Icons.build, "Maintenance Tips", 1, MaintenanceTipsPage(), isDark),
                _buildDrawerItem(context, Icons.car_repair, "Towing Service", 2, TowingRequestPage(), isDark),
                _buildDrawerItem(context, Icons.notifications, "Service Reminders", 3, ReminderPage(), isDark),
                _buildDrawerItem(context, Icons.description, "Documents", 4, Documentspage(), isDark),
                _buildDrawerItem(context, Icons.support, "Support", 5, SupportCenterPage(), isDark),
                _buildDrawerItem(context, Icons.settings, "Settings", 6, ProfileSettingsPage(), isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget with Navigation
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index, Widget page, bool isDark) {
    bool isSelected = widget.selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : isDark? Colors.black : Colors.white,
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

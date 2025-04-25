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
  if (_fullname == null) {
    _fetchFullName();
  }
}

  final _currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> _fetchFullName() async {
  if (_cachedFullname != null) {
    setState(() {
      _fullname = _cachedFullname;
    });
    return;
  }

  if (_currentUser == null) return;
  try {
    final email = _currentUser!.email;
    if (email == null) return;

    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String fullName = userDoc.get("fullname");
      _cachedFullname = fullName;

      setState(() {
        _fullname = fullName;
      });
    }
  } catch (e) {
    debugPrint("Error fetching full name: $e");
  }
}


  @override
  Widget build(BuildContext context) {

  bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
 
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
                      backgroundImage: AssetImage("assets/img/Avatar.png"),
                    ),
                    SizedBox(height: 40,),
                    Text(" ${_fullname ?? "(Loading)"}", style: GoogleFonts.abel(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),),
                  
                  SizedBox(height: 25,),
                     Text(" ${_currentUser!.email ?? "(Loading)"}", style: GoogleFonts.abel(
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

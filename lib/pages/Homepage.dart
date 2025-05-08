// Import statements for required packages and modules
import 'dart:async';

import 'package:carcare/UserProvider.dart';                         // Custom provider to fetch user data
import 'package:carcare/common_widgets/Navigation_Menu.dart';       // Common navigation menu widget
import 'package:carcare/common_widgets/common_widgets.dart';        // Other shared widgets (e.g., AddCarModal, SideMenuDrawer)
import 'package:carcare/theme_provider/themeprovider.dart';         // Theme provider for light/dark mode
import 'package:cloud_firestore/cloud_firestore.dart';             // Firestore database SDK
import 'package:firebase_auth/firebase_auth.dart';                  // Firebase authentication SDK
import 'package:flutter/material.dart';                              // Flutter UI toolkit
import 'package:google_fonts/google_fonts.dart';                    // Google Fonts for custom typography
import 'package:provider/provider.dart';                             // Provider package for state management
import 'package:smooth_page_indicator/smooth_page_indicator.dart';   // Smooth page indicators for PageView
import '../data/data.dart';

// The HomePage widget which is stateful because it handles dynamic data
class HomePage extends StatefulWidget {
  HomePage({super.key}); // Constructor

  @override
  State<HomePage> createState() => _HomePageState(); // Create the mutable state
}

// The state class for HomePage
class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;                                    // Tracks selected item in the side menu
  final FirebaseAuth _auth = FirebaseAuth.instance;         // FirebaseAuth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  final PageController _pageController = PageController();  // Controller for the PageView of cars

  User? _currentUser;                                       // Currently authenticated user
  List<Map<String, dynamic>> _userCars = [];                // List of user's cars fetched from Firestore
  int _currentCarIndex = 0;                                 // Index of currently displayed car in PageView

   List<MaintenanceTip> _activeTips = [];
  List<Map<String, dynamic>> _upcomingReminders = [];       // List of upcoming reminders

   
  DateTime? _lastTipUpdate;
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;                       // Get the currently logged-in user
    // Fetch user details via provider as soon as context is available
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchUserDetails();
    });
    _fetchCars();                                           // Load user's cars from Firestore
    _loadUpcomingReminders();                               // Load upcoming reminders
    _generateTips();
    _tipTimer = Timer.periodic(const Duration(seconds: 2), (_) => _generateTips());
  }

 void _generateTips() {
    final now = DateTime.now();
    if (_lastTipUpdate == null || now.difference(_lastTipUpdate!).inMinutes >= 30) {
      final pool = List<MaintenanceTip>.from(allMaintenanceTips)..shuffle();
      setState(() {
        _activeTips = pool.take(5).toList();
        _lastTipUpdate = now;
      });
    }
  }

  

  /// Fetches the list of cars for the logged-in user from Firestore
  Future<void> _fetchCars() async {
    if (_currentUser == null) return;
    try {
      final email = _currentUser!.email;
      if (email == null) return;
      // Query the 'users' collection by email
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();
      // If user document exists, extract 'cars' field
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        List<dynamic> cars = userDoc.get("cars") ?? [];
        setState(() {
          // Convert dynamic list to List<Map<String, dynamic>>
          _userCars = List<Map<String, dynamic>>.from(cars);
        });
      }
    } catch (e) {
      debugPrint("Error fetching cars: $e"); // Print error if fetch fails
    }
  }

  /// Loads upcoming reminders (date > today) from the user's Firestore document
  Future<void> _loadUpcomingReminders() async {
    final user = _auth.currentUser;
    if (user == null) return;
    // Retrieve the user's document
    final doc = await _firestore.collection("users").doc(user.uid).get();
    final reminders = List<Map<String, dynamic>>.from(doc.data()?['reminders'] ?? []);
    final today = DateTime.now();
    // Filter reminders to those with dates after today
    _upcomingReminders = reminders.where((reminder) {
      final date = DateTime.parse(reminder['date']);
      return date.isAfter(today);
    }).toList();
    setState(() {}); // Trigger UI update
  }


  void _showTipDialog(MaintenanceTip tip, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Colors.white : Colors.black87,
        title: Text(tip.title, style: TextStyle(color: isDark ? Colors.black : Colors.white)),
        content: Text(tip.description, style: TextStyle(color: isDark ? Colors.black87 : Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: isDark ? Colors.black : Colors.white)),
          )
        ],
      ),
    );
  }
  /// Shows a dialog allowing the user to edit a car's brand and model
  void _showEditCarDialog(int index, Map<String, dynamic> car) {
    final brandController = TextEditingController(text: car['brand']);
    final modelController = TextEditingController(text: car['model']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Car"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextField for editing the car brand
            TextField(
              controller: brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            // TextField for editing the car model
            TextField(
              controller: modelController,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
          ],
        ),
        actions: [
          // Cancel button dismisses the dialog
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // Save button updates Firestore and local state
          ElevatedButton(
            onPressed: () async {
              // Update the local list
              _userCars[index]['brand'] = brandController.text;
              _userCars[index]['model'] = modelController.text;
              // Persist changes to Firestore
              await _firestore.collection('users').doc(_currentUser!.uid).update({
                'cars': _userCars,
              });
              setState(() {});  // Refresh UI
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// Deletes a car at the given index both locally and in Firestore
  void _deleteCar(int index) async {
    _userCars.removeAt(index);
    await _firestore.collection('users').doc(_currentUser!.uid).update({
      'cars': _userCars,
    });
    setState(() {
      // Adjust currentCarIndex if needed
      if (_currentCarIndex >= _userCars.length) {
        _currentCarIndex = _userCars.isEmpty ? 0 : _userCars.length - 1;
      }
    });
  }

  /// Shows a dialog displaying full details of a reminder
  void _showReminderDetailsDialog(Map<String, dynamic> reminder, bool isDark) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.white : Colors.black87,
          title: Text(
            reminder['title'] ?? 'Reminder',
            style: TextStyle(color: isDark ? Colors.black : Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date line
              Text("📅 Date: ${reminder['date']}",
                  style: TextStyle(color: isDark ? Colors.black : Colors.white)),
              // Time line
              Text("⏰ Time: ${reminder['time']}",
                  style: TextStyle(color: isDark ? Colors.black : Colors.white)),
              const SizedBox(height: 10),
              // Description header and text
              Text("📝 Description:",
                  style: TextStyle(color: isDark ? Colors.black : Colors.white)),
              Text(reminder['desc'] ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.black : Colors.white)),
            ],
          ),
          actions: [
            // Close button for the dialog
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close",
                  style: TextStyle(color: isDark ? Colors.black : Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Shows a modal bottom sheet to add a new car, enforcing a max of 5 cars
  void showAddCarModal(BuildContext context) {
    if (_userCars.length >= 5) {
      // If limit reached, show an alert
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Limit Reached"),
          content: const Text("You can only add up to 5 cars."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Otherwise, open the AddCarModal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => AddCarModal(onCarAdded: _fetchCars),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);        // Access user data
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;   // Current theme flag

     WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastTipUpdate == null) _generateTips();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.blue : Colors.black87,      // AppBar color based on theme
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),       // Hamburger menu icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),         // Custom side menu
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ======== Welcome & Cars Section ========
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: isDark ? Colors.blue : Colors.black87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Greeting with user's full name
                  Text(
                    "Welcome ${userProvider.fullname ?? "(Loading)"}",
                    style: GoogleFonts.karla(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Shows current car brand & model or a placeholder
                  Text(
                    _userCars.isNotEmpty
                        ? "${_userCars[_currentCarIndex]['brand']} ${_userCars[_currentCarIndex]['model']}"
                        : "No cars available at the moment",
                    style: GoogleFonts.karla(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // PageView of car images with edit/delete buttons
                  SizedBox(
                    height: 230,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _userCars.isNotEmpty ? _userCars.length : 1,
                            onPageChanged: (index) {
                              setState(() {
                                _currentCarIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (_userCars.isEmpty) {
                                // Placeholder when no cars exist
                                return Center(
                                  child: Text(
                                    "No car found",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }
                              // Car display with top-view image
                              final car = _userCars[index];
                              return Column(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      CarCareImages.White_Car_topview,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // Edit & delete icons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.white),
                                        onPressed: () => _showEditCarDialog(index, car),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () => _deleteCar(index),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Page indicator dots
                        if (_userCars.isNotEmpty)
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: _userCars.length,
                            effect: WormEffect(
                              dotColor: Colors.white24,
                              activeDotColor: Colors.white,
                              dotHeight: 10,
                              dotWidth: 10,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // ======== Upcoming Reminders Section ========
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black12 : Colors.white24,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upcoming Reminders",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: _upcomingReminders.isEmpty
                        // Placeholder if no upcoming reminders
                        ? Center(
                            child: Text(
                              "No upcoming reminders at the moment.",
                              style: TextStyle(color: isDark ? Colors.black : Colors.white),
                            ),
                          )
                        // Horizontal list of reminder cards
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _upcomingReminders.length,
                            itemBuilder: (context, index) {
                              final reminder = _upcomingReminders[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    _showReminderDetailsDialog(reminder, isDark);
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isDark ? Colors.white : Colors.black87,
                                      border: Border.all(color: const Color(0xFFB3B2B2)),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.notifications, color: Colors.red),
                                        const SizedBox(height: 5),
                                        // Reminder title
                                        Text(
                                          reminder['title'] ?? '',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isDark ? Colors.black : Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // ======== Daily Tips Section ========
            Container(
              decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black87),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daily Tips",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Scrollable list of TipCard widgets
                  AnimatedSwitcher(
  duration: const Duration(seconds: 5),
  switchInCurve: Curves.easeIn,
  switchOutCurve: Curves.easeOut,
  child: SizedBox(
    // give each generation a unique key so AnimatedSwitcher knows it changed:
    key: ValueKey<DateTime>(_lastTipUpdate!),
    height: 250,
    child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: _activeTips.length,
      itemBuilder: (_, i) {
        final tip = _activeTips[i];
        return GestureDetector(
          onTap: () => _showTipDialog(tip, isDark),
          child: TipCard(tip.title, tip.description, isDark),
        );
      },
    ),
  ),
),

                ],
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add a new car
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddCarModal(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

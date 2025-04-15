import 'package:carcare/common_widgets/Navigation_Menu.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; 

class HomePage extends StatefulWidget {
   HomePage({super.key , required this.Theme});
   bool Theme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // at the top

// Add this controller in your _HomePageState
final PageController _pageController = PageController();


  User? _currentUser;
  String? _fullName;

  List<Map<String, dynamic>> _userCars = [];
  int _currentCarIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchFullName();
    _fetchCars();
    _loadUpcomingReminders();
  }

void _showReminderDetailsDialog(Map<String, dynamic> reminder) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(reminder['title'] ?? 'Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📅 Date: ${reminder['date']}"),
            Text("⏰ Time: ${reminder['time']}"),
            const SizedBox(height: 10),
            Text("📝 Description:"),
            Text(reminder['desc'] ?? '', style: const TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}




  List<Map<String, dynamic>> _upcomingReminders = [];

Future<void> _loadUpcomingReminders() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final doc = await _firestore.collection("users").doc(user.uid).get();
  final reminders = List<Map<String, dynamic>>.from(doc.data()?['reminders'] ?? []);

  final today = DateTime.now();

  _upcomingReminders = reminders.where((reminder) {
    final date = DateTime.parse(reminder['date']);
    return date.isAfter(today);
  }).toList();

  setState(() {});
}


  Future<void> _fetchFullName() async {
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
        setState(() {
          _fullName = userDoc.get("fullname") as String?;
        });
      }
    } catch (e) {
      debugPrint("Error fetching full name: $e");
    }
  }

  Future<void> _fetchCars() async {
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
        List<dynamic> cars = userDoc.get("cars") ?? [];
        setState(() {
          _userCars = List<Map<String, dynamic>>.from(cars);
        });
      }
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void showAddCarModal(BuildContext context) {
    if (_userCars.length >= 5) {
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
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => AddCarModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Welcome ${_fullName ?? "(Loading)"}",
                    style: GoogleFonts.karla(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
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
            return Image.asset(
              CarCareImages.White_Car_topview,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
      const SizedBox(height: 10),
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

            // Upcoming Reminders Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),

                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upcoming Reminders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                 SizedBox(
  height: 80,
  child: _upcomingReminders.isEmpty
      ? Center(child: Text("No upcoming reminders at the moment."))
      : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _upcomingReminders.length,
          itemBuilder: (context, index) {
            final reminder = _upcomingReminders[index];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: (){
                  _showReminderDetailsDialog(_upcomingReminders[index]);
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFB3B2B2)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.notifications, color: Colors.red),
                      const SizedBox(height: 5),
                      Text(reminder['title'] ?? '', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
)
,
                ],
              ),
            ),

            // Daily Tips Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Tips",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 250,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        TipCard("Insurance Renewal", "Your insurance will be...dvavcadcadcaccqa"),
                        TipCard("Insurance Renewal Reminder", "Please don't forget to r..."),
                        TipCard("Urgent Insurance Renewal", "Consider updating you..."),
                        TipCard("Renewal Notification", "Protect yourself and y..."),
                        TipCard("Insurance Renewal Alert", "Stay secure and renew..."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class SupportCenterPage extends StatefulWidget {
  @override
  _SupportCenterPageState createState() => _SupportCenterPageState();
}

class _SupportCenterPageState extends State<SupportCenterPage> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  List<bool> _expandedList = List.generate(5, (index) => false);

    int selectedIndex = 5;


  final List<Map<String, String>> faqs = [
    {
      "question": "How do I request towing services?",
      "answer": "You can request towing services via the app's Towing Service section."
    },
    {
      "question": "Can I track my vehicle’s health in real-time?",
      "answer": "Yes, our app provides real-time vehicle health monitoring."
    },
    {
      "question": "How do I upload my vehicle documents?",
      "answer": "Go to the Documents section and upload your vehicle documents securely."
    },
    {
      "question": "Can I add multiple vehicles?",
      "answer": "Yes, you can register up to 5 vehicles under one account."
    },
    {
      "question": "What should I do if my account is locked?",
      "answer": "Contact support to verify your identity and unlock your account."
    },
  ];

  void _toggleExpand(int index) {
    setState(() {
      _expandedList[index] = !_expandedList[index];
    });
  }

void _launchPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  try {
    await launchUrl(phoneUri);
  } catch (e) {
    print("Could not launch dialer: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: _scaffoldKey,
      appBar: AppBar(
          leading: IconButton(icon:Icon(Icons.menu),
          onPressed: (){
            _scaffoldKey.currentState?.openDrawer();
          },
          ),
      ),

      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Support Center", style: GoogleFonts.lexendDeca(fontSize: 22, fontWeight: FontWeight.normal)),
            const SizedBox(height: 20),

            // Call Us & Chat With Us Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSupportCard("Call Us", "assets/img/Call_holder.png"),
                _buildSupportCard("Chat With Us", "assets/img/Woman_chattingonline.png"),
              ],
            ),
            const SizedBox(height: 20),

            // Frequently Asked Questions Section
            Text("Frequently Asked Questions", style: GoogleFonts.karla(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(faqs[index]["question"]!, style: GoogleFonts.lexendDeca(fontSize: 16 , fontWeight: FontWeight.normal)),
                          trailing: Icon(_expandedList[index] ? Icons.remove : Icons.add),
                          onTap: () => _toggleExpand(index),
                        ),
                        if (_expandedList[index])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                            child: Text(faqs[index]["answer"]!, style: GoogleFonts.karla(fontSize: 14)),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for "Call Us" and "Chat With Us" buttons
  Widget _buildSupportCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
       if (title == "Call Us") {
    _launchPhoneDialer("+233501234567"); // Replace with your actual support number
  } else {
    print("$title clicked");
  }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            title,
            style: GoogleFonts.karla(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

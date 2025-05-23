import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:carcare/pages/ChatWithUspage.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
     bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
       key: _scaffoldKey,
       backgroundColor: isDark? Colors.white : Colors.black87,
      appBar: AppBar(
        backgroundColor:isDark? Colors.blue : Colors.black87 ,
          leading: IconButton(icon:Icon(Icons.menu, color: isDark ? Colors.black : Colors.white ,),
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
            Text("Support Center", style: GoogleFonts.lexendDeca(fontSize: 22, fontWeight: FontWeight.normal,
            color: Colors.white
            )),
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
            Text("Frequently Asked Questions", style: GoogleFonts.karla(fontSize: 18, fontWeight: FontWeight.bold,
              color: isDark? Colors.black : Colors.white
            )),
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
                          tileColor: isDark? const Color.fromARGB(255, 248, 245, 245) : const Color.fromARGB(148, 0, 0, 0),
                          title: Text(faqs[index]["question"]!, style: GoogleFonts.lexendDeca(fontSize: 16 , fontWeight: FontWeight.normal,
                         color: isDark? Colors.black : Colors.white
                          )),
                          trailing: Icon(_expandedList[index] ? Icons.remove : Icons.add ,color:isDark? Colors.black : Colors.white ,),
                          onTap: () => _toggleExpand(index),
                        ),
                        if (_expandedList[index])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                            decoration: BoxDecoration(
                             color: isDark? const Color.fromARGB(255, 248, 245, 245)   : const Color.fromARGB(148, 0, 0, 0) 
                            ),
                            
                            child: Text(faqs[index]["answer"]!, style: GoogleFonts.karla(fontSize: 14,
                            color: isDark? Colors.black : Colors.white
                            ))
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
    _launchPhoneDialer("+233501234567"); 
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatPage() ));
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

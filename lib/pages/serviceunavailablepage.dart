import 'dart:async';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:flutter/material.dart';

class ServiceUnavailablePage extends StatefulWidget {
  @override
  _ServiceUnavailablePageState createState() => _ServiceUnavailablePageState();
}

class _ServiceUnavailablePageState extends State<ServiceUnavailablePage> {
  String dots = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startDotAnimation();
  }

  void _startDotAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (dots.length >= 3) {
          dots = "";
        } else {
          dots += ".";
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Service Unavailable.\nPlease kindly wait$dots",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainNavigatorPage()),
                  );
                },
                icon: Icon(Icons.home),
                label: Text("Return to Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[700],
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

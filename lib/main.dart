import 'package:carcare/blankscreen.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:carcare/pages/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Care App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        
      ),
      home:Splashpage()
    );
  }
}


 
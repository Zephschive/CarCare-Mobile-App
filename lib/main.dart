import 'package:carcare/UserProvider.dart';
import 'package:carcare/blankscreen.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:carcare/pages/SplashPage.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


void main() async {
    Gemini.init(
    apiKey: '',
  );

  MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider())
  ]);
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
   ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
       duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        data: ThemeProvider().isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: MaterialApp(
        title: 'Car Care App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          
          useMaterial3: false,
          
        ),
        home:Splashpage()
      ),
    );
  }
}


 
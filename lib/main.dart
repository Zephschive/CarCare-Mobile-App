// lib/main.dart
import 'package\:carcare/ConnectivityProvider.dart';
import 'package\:carcare/UserProvider.dart';
import 'package\:carcare/pages/SplashPage.dart';
import 'package\:carcare/theme\_provider/themeprovider.dart';
import 'package\:flutter/material.dart';
import 'package\:firebase\_core/firebase\_core.dart';
import 'package\:flutter\_gemini/flutter\_gemini.dart';
import 'firebase\_options.dart';
import 'package:provider/provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
Gemini.init(apiKey: 'AIzaSyCS177rfuggxOgsrNB0yZyl6BaGyqNWVsY');

runApp(
MultiProvider(
providers: [
ChangeNotifierProvider(create: (_) => ThemeProvider()),
ChangeNotifierProvider(create: (_) => UserProvider()),
ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
],
child: const MyApp(),
),
);
}

class MyApp extends StatelessWidget {
const MyApp({super.key});
@override
Widget build(BuildContext context) {
final themeProvider = Provider.of<ThemeProvider>(context);
return MaterialApp(
title: 'Car Care App',
debugShowCheckedModeBanner: false,
theme: ThemeData.light(),
darkTheme: ThemeData.dark(),
themeMode: themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
builder: (context, child) {
// Wrap every page in a Stack so we can overlay the "offline" banner
return Stack(
children: [
child!,
Consumer<ConnectivityProvider>(
builder: (context, conn, _) {
if (!conn.isOnline) {
return Positioned(
top: MediaQuery.of(context).padding.top,
left: 0,
right: 0,
child: Container(
color: Colors.red,
padding: const EdgeInsets.symmetric(vertical: 8),
child: const Center(
child: Text(
'No internet connection',
style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
),
),
),
);
}
return const SizedBox.shrink();
},
),
],
);
},
home: const Splashpage(),
);
}
}


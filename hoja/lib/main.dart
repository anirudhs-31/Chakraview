import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoja/register.dart';
import 'package:hoja/splash_screen.dart';
 // Import your splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      initialRoute: 'splash', // Set the initial route to 'splash'
      routes: {
        'splash': (context) => SplashScreen(), // Define the SplashScreen route
        'register': (context) => RegisterPage(),
      },
    );
  }
}

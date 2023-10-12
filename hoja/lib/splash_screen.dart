import 'package:flutter/material.dart';
import 'package:hoja/login.dart';  // Import the login page or your home page

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds and then navigate to the login page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),  // Replace with your login page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ChakraView",
              style: TextStyle(
                fontSize: 48,  // Bigger font size
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B4513),  // Khaki color
              ),
            ),
            const SizedBox(height: 20),  // Gap between lines
            Text(
              "Humari Nazar Aaape hai",
              style: TextStyle(
                fontSize: 24,  // Regular font size
                fontWeight: FontWeight.normal,
                color: Colors.black,  // Black color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

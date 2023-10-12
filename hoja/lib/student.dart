import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoja/login.dart';
import 'package:hoja/map_page.dart'; // Import MapPage

class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    // Fetch the user's name and email from Firebase Firestore
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        userName = userData.get('name');
        userEmail = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
            ),
            ListTile(
              title: const Text("Show Slots"),
              leading: const Icon(Icons.schedule),
              onTap: () {
                // Handle "Show Slots" action here
                // You can navigate to the desired screen or perform any other action.
              },
            ),
            ListTile(
              title: const Text("Notification"),
              leading: const Icon(Icons.notifications),
              onTap: () {
                _showNotificationDialog();
              },
            ),
            ListTile(
              title: const Text("SOS"),
              leading: const Icon(Icons.warning),
              onTap: () {
                // Handle "SOS" action here
                // You can navigate to the desired screen or perform any other action.
              },
            ),
            ListTile(
              title: const Text("Give Location"),
              leading: const Icon(Icons.location_on),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage())); // Navigate to MapPage
              },
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Welcome, $userName!"),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: const Text("Please completely charge your phone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

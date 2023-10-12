import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoja/login.dart';
import 'package:hoja/geofence.dart';
import 'package:hoja/map_page.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        actions: [
          IconButton(
            onPressed: () {
              _logout(context);  // Calls the logout function
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text("Create Geofence"),
              leading: const Icon(Icons.location_on),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyMapPage()));
                // Handle "Create Geofence" action here
                // You can navigate to the desired screen or perform any other action.
              },
            ),
            ListTile(
              title: const Text("Show Police Users"),
              leading: const Icon(Icons.people),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPage()));
                // Handle "Show Police Users" action here
                // You can navigate to the desired screen or perform any other action.
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Welcome, Admin!"),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}

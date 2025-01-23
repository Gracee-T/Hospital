import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';
import 'package:flutter_application_1/widgets/app_bar_title.dart';
import 'package:provider/provider.dart';

// Widget for the main page after user login, displays user information and navigation options
class PatientMainPage extends StatelessWidget {
  const PatientMainPage({super.key});

  // Function to fetch user data from Firestore
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Patients').doc(user.uid).get();

    return userDoc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Selector<AppBarTitle, String>(
          selector: (_, appBarTitle) => appBarTitle.title,
          builder: (context, title, child) {
            return Row(
              children: [
                Image.asset(
                  'assets/Logo.jpg', // Update with the path to your logo
                  height: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, RouteManager.loginPage);
            },
          ),
        ],
      ),
     
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User data not found'));
          }

          final userData = snapshot.data!;
          final fullName = userData['fullName'] ?? 'User';
          final currentUser = FirebaseAuth.instance.currentUser;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display user information
                const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('assets/Logo.jpg'), // Update with the path to your logo
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome: ${currentUser!.displayName ?? fullName}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,),
                ),
                const SizedBox(height: 40),
                // Buttons for navigation options
                  buildButton(context, 'Profile', RouteManager.patientProfilePage),
                    const SizedBox(height: 20),
                buildButton(context, 'Appointment', RouteManager.bookAppointmentsPage),
              
              
                const SizedBox(height: 20),
                buildButton(context, 'Review', RouteManager.reviewPage),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, String route) {
    return SizedBox(
      width: 200, // Set a fixed width for all buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

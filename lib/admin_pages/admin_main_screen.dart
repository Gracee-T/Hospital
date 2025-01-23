import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';

import 'package:flutter_application_1/widgets/app_bar_title.dart';
import 'package:provider/provider.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('Administrators')
            .doc(user.uid)
            .get();

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
                  'assets/Logo.jpg',
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
          final name = userData['name'] ?? 'User';
          final surname = userData['surname'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome: $name $surname', //===============
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                _buildElevatedButton(
                  context,
                  label: 'View Appointments',
                  routeName: RouteManager.adminViewAppointmentsPage,
                ),
                const SizedBox(height: 20),
                _buildElevatedButton(
                  context,
                  label: 'View Profile',
                  routeName: RouteManager.adminProfilePage,
                ),
                const SizedBox(height: 20),
                _buildElevatedButton(
                  context,
                  label: 'View Reviews',
                  routeName: RouteManager.adminViewReviewsPage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context,
      {required String label, required String routeName}) {
    return SizedBox(
      width: 250, // Consistent button width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

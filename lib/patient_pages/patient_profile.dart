import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/patient_pages/sign_screen.dart';
 // Assuming you have this file

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!; // Get the current authenticated user
  final usersCollection = FirebaseFirestore.instance.collection('Patients'); // Reference to the 'Patients' collection

  Future<void> showEditDialog(String field, String value) async {
    String newValue = value;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: TextEditingController(text: value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.black),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              saveField(field, newValue);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveField(String field, String newValue) async {
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'You successfully signed out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  duration: Duration(seconds: 2),
                ));
              });
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
     
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser.uid).snapshots(), // Listen to real-time updates from Firestore
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                const Icon(Icons.person, size: 100, color: Colors.green,),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                const SizedBox(height: 20),
                buildRow('Full Name', userData['fullName'] ?? '', () {
                  showEditDialog('fullName', userData['fullName'] ?? '');
                }),
                buildRow('Email', userData['email'] ?? '', () {
                  showEditDialog('email', userData['email'] ?? '');
                }),
                buildRow('ID Number', userData['idNumber'] ?? '', () {
                  showEditDialog('idNumber', userData['idNumber'] ?? '');
                }),
                buildRow('Date of Birth', userData['dateOfBirth'] ?? '', () {
                  showEditDialog('dateOfBirth', userData['dateOfBirth'] ?? '');
                }),
                buildRow('Phone Number', userData['contactNumber'] ?? '', () {
                  showEditDialog('contactNumber', userData['contactNumber'] ?? '');
                }),
                const SizedBox(height: 20),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildRow(String field, String value, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

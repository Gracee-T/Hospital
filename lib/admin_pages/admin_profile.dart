import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/patient_pages/sign_screen.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Administrators');

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  // Function to show an edit dialog
  Future<void> showEditDialog(String field, TextEditingController controller) async {
    String newValue = controller.text;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Edit $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
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
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Save button
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

  // Function to save edited field
  Future<void> saveField(String field, String newValue) async {
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Profile'),
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            nameController.text = userData['name'] ?? '';
            contactNumberController.text = userData['contactNumber'] ?? '';

            return ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.person, size: 100, color: Colors.green,),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  
                ),
                const SizedBox(height: 20),
                buildEditableRow('Name', nameController, () {
                  showEditDialog('name', nameController);
                }),
                buildEditableRow('Phone Number', contactNumberController, () {
                  showEditDialog('contactNumber', contactNumberController);
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

  // Function to build an editable row
  Widget buildEditableRow(String field, TextEditingController controller, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                controller.text,
                style: const TextStyle(color: Colors.black, fontSize: 16),
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

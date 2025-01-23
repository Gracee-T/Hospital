import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';

// Widget for the review page where users can submit their reviews
class PatientReviewPage extends StatefulWidget {
  const PatientReviewPage({super.key});

  @override
  _PatientReviewPageState createState() => _PatientReviewPageState();
}

class _PatientReviewPageState extends State<PatientReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _hospitalNameController = TextEditingController();
  final _reviewController = TextEditingController();

  // Function to fetch user data from Firestore
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Patients').doc(user.uid).get();

    return userDoc.data();
  }

  // Function to submit the review
  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final userData = await _fetchUserData();
      final fullName = userData?['fullName'] ?? 'User';
      final String hospitalName = _hospitalNameController.text;
      final String review = _reviewController.text;

      await FirebaseFirestore.instance.collection('Reviews').add({
        'userId': currentUser.uid,
        'userName': currentUser.displayName,
        'userEmail': currentUser.email,
        'hospitalName': hospitalName,
        'review': review,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$fullName, your review is received',
          style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: Colors.green // Change background color to teal),
        ),
      );

      _hospitalNameController.clear();
      _reviewController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
      appBar: AppBar(
        
        backgroundColor: Colors.green,
        title: const Text(
          ' Review',
          style: TextStyle(color: Colors.white),
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Provide your feedback',
                style: TextStyle(fontSize: 18, color:  Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _hospitalNameController,
                
                decoration: const InputDecoration(
                  labelText: 'Hospital name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the hospital';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: _submitReview,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

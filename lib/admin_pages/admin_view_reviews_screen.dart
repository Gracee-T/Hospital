// Importing necessary packages and widgets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';

import 'package:intl/intl.dart';

// StatelessWidget for viewing reviews
class AdminViewReviewsPage extends StatelessWidget {
  const AdminViewReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'View Reviews',
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
      
      body: const ReviewsList(),
    );
  }
}

// StatelessWidget for displaying list of reviews
class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final reviews = snapshot.data!.docs;
        if (reviews.isEmpty) {
          return const Center(child: Text('No reviews found'));
        }
        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ReviewItem(review: review);
          },
        );
      },
    );
  }
}

// StatelessWidget for displaying each review item
class ReviewItem extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = review.data() as Map<String, dynamic>;
    final String hospitalName = data['hospitalName'] ?? 'Unknown Hospital';
    final String userEmail = data['userEmail'] ?? 'Unknown Email';
    final String reviewText = data['review'] ?? 'No review provided';
    final DateTime timestamp = (data['timestamp'] as Timestamp).toDate();

    // Fetch user's full name
    final String userId = data['userId'];
    final Future<DocumentSnapshot<Map<String, dynamic>>> userSnapshot =
        FirebaseFirestore.instance.collection('Patients').doc(userId).get();

    return FutureBuilder<DocumentSnapshot>(
      future: userSnapshot,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (userSnapshot.hasError) {
          return Text('Error fetching user: ${userSnapshot.error}');
        }
        final userData = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
        final String fullName = userData['fullName'] ?? 'Unknown User';

        // Format the date and time
        final String formattedDate = DateFormat('yyyy-MM-dd').format(timestamp);
        final String formattedTime = DateFormat('HH:mm').format(timestamp);

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: ListTile(
              title: Text(hospitalName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Review: $reviewText', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('By: $fullName ($userEmail)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('On: $formattedDate at $formattedTime', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Review?'),
                        content: const Text('Are you sure you want to delete this review?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              review.reference.delete();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// View Appointments Page

// Importing necessary packages and widgets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';

import 'package:intl/intl.dart';

// StatelessWidget for viewing appointments
class AdminViewAppointmentsPage extends StatelessWidget {
  const AdminViewAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'View Appointments',
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
      
      body: const PatientAppointmentsList(),
    );
  }
}

// StatelessWidget for displaying list of appointments
class PatientAppointmentsList extends StatelessWidget {
  const PatientAppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Bookings').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final appointments = snapshot.data!.docs;
        if (appointments.isEmpty) {
          return const Center(child: Text('No appointments found'));
        }
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Patients').doc(appointment['userId']).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return Text('Error fetching user: ${userSnapshot.error}');
                }
                final userData = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                return Appointments(
                  appointment: appointment,
                  userData: userData,
                );
              },
            );
          },
        );
      },
    );
  }
}

// StatelessWidget for displaying each appointment item
class Appointments extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> appointment;
  final Map<String, dynamic> userData;

  const Appointments({super.key, required this.appointment, required this.userData});

  @override
  Widget build(BuildContext context) {
    final String fullName = userData['fullName'] ?? 'Unknown';
    final String userEmail = userData['email'] ?? 'Unknown Email';
    final DateTime appointmentDateTime = (appointment['appointmentDateTime'] as Timestamp).toDate();
    final String reason = appointment['reason'] ?? 'No reason provided';

    final String formattedDate = DateFormat('yyyy-MM-dd').format(appointmentDateTime);
    final String formattedTime = TimeOfDay.fromDateTime(appointmentDateTime).format(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: ListTile(
          title: Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: $userEmail', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Date: $formattedDate', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Time: $formattedTime', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Reason: $reason', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Appointment?'),
                    content: const Text('Are you sure you want to delete this appointment?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          appointment.reference.delete();
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
  }
}

// Importing necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';

// StatefulWidget for booking appointments
class BookAppointmentsPages extends StatefulWidget {
  const BookAppointmentsPages({super.key});

  @override
  _BookAppointmentsPagesState createState() => _BookAppointmentsPagesState();
}

// State class for BookAppointmentsPages
class _BookAppointmentsPagesState extends State<BookAppointmentsPages> {
  // Global key for the form
  final _formKey = GlobalKey<FormState>();
  // Controller for reason input
  final _reasonController = TextEditingController();
  // Variables for selected date and time
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Function to fetch user data from Firestore
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Patients').doc(user.uid).get();

    return userDoc.data();
  }

  // Function to pick date using DatePicker
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to pick time using TimePicker
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  // Function to submit appointment details
  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser!;
      final String reason = _reasonController.text;
      final DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      await FirebaseFirestore.instance.collection('Bookings').add({
        'userId': currentUser.uid,
        'userName': currentUser.displayName,
        'userEmail': currentUser.email,
        'reason': reason,
        'appointmentDateTime': appointmentDateTime,
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: FutureBuilder<Map<String, dynamic>?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Text('Your appointment is received');
              }

              final userData = snapshot.data!;
              final fullName = userData['fullName'] ?? 'User';

              return Text('$fullName, your appointment is received');
            },
          ),
          
        ),
      );

      _reasonController.clear();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  // Build method to construct UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Book Appointments',
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
                'Select Date and Time for Appointment',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // ListTile for date selection
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  style:  const TextStyle( color: Colors.white),
                  _selectedDate == null
                      ? 'No date selected'
                      : '${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _pickDate,
                  child: const Text('Date'),
                ),
              ),
              const SizedBox(height: 20),
              // ListTile for time selection
              ListTile(
                
                leading: const Icon(Icons.access_time),
                title: Text(
                      style:  const TextStyle( color: Colors.white),
                  _selectedTime == null
                      ? 'No time selected'
                      : _selectedTime!.format(context),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _pickTime,
                  child: const Text('Time'),
                ),
              ),
              const SizedBox(height: 20),
              // TextFormField for reason input
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Feedback', 
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason';
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
                onPressed: _submitAppointment,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


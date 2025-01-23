// ignore_for_file: use_build_context_synchronously

// Importing necessary packages and widgets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/patient_pages/sign_screen.dart';
import 'package:flutter_application_1/routes/route.dart';

// StatefulWidget for Admin Registration Page
class AdminRegistrationPage extends StatefulWidget {
  final UserType userType;
  const AdminRegistrationPage({super.key, required this.userType});

  @override
  State<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

// State class for AdminRegistrationPage
class _AdminRegistrationPageState extends State<AdminRegistrationPage> {
  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variables for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Error and success messages
  String _errorMessage = '';
  String _successMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        title: Text(
          widget.userType == UserType.patient
              ? 'Patient Registration Form'
              : 'Admin Registration Form',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    prefixIcon: Icon(Icons.phone, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Contact number must be exactly 10 digits long and contain only numbers';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.trim().contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().length < 8 || !value.trim().contains('@')) {
                      return 'Password must be at least 8 characters long and contain "@" symbol';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty || value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_successMessage.isNotEmpty)
                  Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
     
    ));
  }

  // Function to handle registration process
  void _register() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    try {
      // Creating user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Adding user details to Firestore
      FirebaseFirestore.instance
          .collection(widget.userType == UserType.patient ? 'Patients' : 'Administrators')
          .doc(userCredential.user?.uid)
          .set({
        'name': _nameController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
        'email': _emailController.text.trim(),
      });

      // Showing success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.userType == UserType.patient
              ? 'Patient registered successfully'
              : 'Admin registered successfully',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: Colors.green // Change background color to teal),
              
        ),
      );

      // Navigating to login page
      Navigator.pushReplacementNamed(context, RouteManager.loginPage);
    } on FirebaseAuthException catch (e) {
      // Handling FirebaseAuthException
      setState(() {
        _errorMessage = e.message ?? 'An error occurred';
        _successMessage = '';
      });
    }
  }

  // Function to check if string is numeric
  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}

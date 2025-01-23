import 'package:cloud_firestore/cloud_firestore.dart';  // Importing Firestore package
import 'package:firebase_auth/firebase_auth.dart';  // Importing FirebaseAuth package
import 'package:flutter/material.dart';  // Importing Flutter material package
import 'package:flutter_application_1/routes/route.dart';  // Importing route manager
import 'package:flutter_application_1/widgets/custom_textfield.dart';  // Importing custom text field widget

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});  // Constructor for LoginForm

  @override
  _LoginFormState createState() => _LoginFormState();  // Creating state for LoginForm
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();  // Form key for validation
  final TextEditingController _emailController = TextEditingController();  // Controller for email field
  final TextEditingController _passwordController = TextEditingController();  // Controller for password field

  bool _obscurePassword = true;  // Password visibility toggle
  String _errorMessage = '';  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,  // Assigning form key
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,  // Stretching children to full width
        children: <Widget>[
          EmailTextField(
            controller: _emailController,  // Assigning email controller
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address';  // Validating email
              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value.trim())) {
                return 'Please enter a valid email address';  // Validating email format
              }
              return null;  // No error
            },
          ),
          const SizedBox(height: 15),  // Adding space between fields
          PasswordTextField(
            controller: _passwordController,  
            obscureText: _obscurePassword,  
            onSuffixIconPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;  // Toggling password visibility
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';  // Validating password
              } else if (value.trim().length < 8) {
                return 'Password must be at least 8 characters long';  // Validating password length
              }
              return null;  // No error
            },
          ),
          const SizedBox(height: 10),  // Adding space
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),  // Padding for error message
              child: Text(
                _errorMessage,  // Displaying error message
                style: const TextStyle(
                  color: Colors.red,  
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),  // Padding for button
           child: ElevatedButton(
            onPressed: _login, 
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,  // Button text color
              backgroundColor: Colors.green,  // Button background color
              minimumSize: const Size(50, 50),  // Set the button to be 50x50 pixels
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,  
              ),
            ),
            child: const Text(
              'Login',  // Button text
              style: TextStyle(fontSize: 20),  // Button text style
            ),
          ),

                    ),
                  ],
                ),
              );
            }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {  // Checking form validation
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),  // Signing in with email
          password: _passwordController.text.trim(),  // Signing in with password
        );

        final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('Patients')
                .doc(userCredential.user!.uid)
                .get();  // Fetching user data from Firestore

        String userType = userSnapshot.exists ? 'patient' : 'admin';  // Determining user type

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userType == 'patient'
                  ? 'You have successfully signed in as a patient'
                  : 'You have successfully signed in as an admin',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            backgroundColor: Colors.green // Change background color to teal
          ));


        Navigator.pushReplacementNamed(
          context,
          userType == 'patient'
              ? RouteManager.patientMainPage
              : RouteManager.adminMainPage,  // Navigating to respective main page
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage = 'No user found with that email address.';  // Handling user not found error
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage = 'The password is incorrect.';  // Handling incorrect password error
          });
        } else {
          setState(() {
            _errorMessage =
                'Email or Password wrong. Please check your credentials.';  // Handling other errors
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage =
              'Email or Password wrong. Please check your credentials.';  // Handling general error
        });
      }
    }
  }
}

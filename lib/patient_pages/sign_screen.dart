import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/route.dart';
import 'package:flutter_application_1/widgets/login_form.dart';

// Enumeration for user types
enum UserType { patient, admin }

// Widget for the login page
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 52, 126, 112),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                // Hospital logo image
                Image.asset(
                  'assets/Logo.jpg', // Assuming you have an image asset for your logo
                  height: 100,
                ),
                const SizedBox(height: 30),
                // Title text
                const Text(
                  'Hospital',
                  style: TextStyle(
                    color: Colors.green, // Title text color
                    fontWeight: FontWeight.bold, // Title text bold
                    fontSize: 20, // Title text size
                  ),
                ),
                const SizedBox(height: 30),
                // Login form widget
                const LoginForm(),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Button to navigate to user registration page
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouteManager.patientRegistrationPage);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Register as Patient?',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 19,
                                
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Button to navigate to admin registration page
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, RouteManager.adminRegistrationPage);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Register as Admin?',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 19,
                                
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

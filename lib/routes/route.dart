import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_pages/admin_main_screen.dart';
import 'package:flutter_application_1/admin_pages/admin_profile.dart';
import 'package:flutter_application_1/admin_pages/admin_registration.dart';
import 'package:flutter_application_1/admin_pages/admin_view_appointments_screen.dart';
import 'package:flutter_application_1/admin_pages/admin_view_reviews_screen.dart';
import 'package:flutter_application_1/patient_pages/sign_screen.dart';
import 'package:flutter_application_1/patient_pages/book_appointments.dart';
import 'package:flutter_application_1/patient_pages/patient_main_screen.dart';
import 'package:flutter_application_1/patient_pages/patient_registration_screen.dart';
import 'package:flutter_application_1/patient_pages/review_screen.dart';
import 'package:flutter_application_1/patient_pages/patient_profile.dart';

class RouteManager {

  static const String loginPage = '/'; // Route for login page
  static const String adminloginPage = '/login'; // Route for admin login page (duplicate)
  static const String adminLoginPage = '/adminLoginPage'; // Route for admin login page
  static const String patientRegistrationPage = '/patientRegistrationPage'; // Route for user registration page
  static const String adminRegistrationPage = '/adminRegistrationPage'; // Route for admin registration page
  static const String patientMainPage = '/patientMainPage'; // Route for user main page
  static const String adminMainPage = '/adminMainPage'; // Route for admin main page
  static const String adminViewAppointmentsPage = '/adminViewAppointmentsPage'; // Route for viewing appointments page
  static const String adminViewReviewsPage = '/adminViewReviewsPage'; // Route for viewing reviews page
  static const String patientProfilePage = '/patientProfilePage'; // Route for user profile page
  static const String adminProfilePage = '/adminProfilePage'; // Route for admin profile page
  static const String bookAppointmentsPage = '/bookAppointmentsPage'; // Route for booking appointments page
  static const String reviewPage = '/reviewPage'; // Route for review page

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(), // Load login page
        );
      case patientRegistrationPage:
        return MaterialPageRoute(
          builder: (context) => const PatientRegistrationPage(userType: UserType.patient), // Load user registration page
        );
      case adminRegistrationPage:
        return MaterialPageRoute(
          builder: (context) => const AdminRegistrationPage(userType: UserType.admin), // Load admin registration page
        );
      case patientMainPage:
        return MaterialPageRoute(
          builder: (context) => const PatientMainPage(), // Load user main page
        );
      case adminMainPage:
        return MaterialPageRoute(
          builder: (context) => const AdminMainPage(), // Load admin main page
        );
      case adminViewAppointmentsPage:
        return MaterialPageRoute(
          builder: (context) => const AdminViewAppointmentsPage(), // Load view appointments page
        );
      case adminViewReviewsPage:
        return MaterialPageRoute(
          builder: (context) => const AdminViewReviewsPage(), // Load view reviews page
        );
      case patientProfilePage:
        return MaterialPageRoute(
          builder: (context) => const PatientProfilePage(), // Load user profile page
        );
      case adminProfilePage:
        return MaterialPageRoute(
          builder: (context) => const AdminProfilePage(), // Load admin profile page
        );
      case reviewPage:
        return MaterialPageRoute(
          builder: (context) => const PatientReviewPage(), // Load review page
        );
      case bookAppointmentsPage:
        return MaterialPageRoute(
          builder: (context) => const BookAppointmentsPages(), // Load book appointments page
        );
      default:
        throw const FormatException('Page does not exist.'); // Throw exception if page does not exist
    }
  }
}

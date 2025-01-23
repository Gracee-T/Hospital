import 'package:flutter/material.dart'; // Importing Flutter material package
import 'dart:io';
import 'package:firebase_core/firebase_core.dart'; // Importing Firebase core package
import 'package:flutter_application_1/routes/route.dart'; // Importing route manager
import 'package:flutter_application_1/widgets/app_bar_title.dart'; // Importing AppBarTitle widget
import 'package:provider/provider.dart'; // Importing provider package

/*

Group Members:
TN Sibanyoni  222019339
AR Sihlangu   222085102
G Tshabalala  221007790
WS Mohapi     222029511

 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensuring Flutter binding

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      // Initializing Firebase for Android
      options: const FirebaseOptions(
          apiKey: "AIzaSyBSSqfT8ZC51RBKB2iQWRjPhC6ZvWhWW3A",
          authDomain: "wendy-7987c.firebaseapp.com",
          projectId: "wendy-7987c",
          storageBucket: "wendy-7987c.appspot.com",
          messagingSenderId: "214429475023",
          appId: "1:214429475023:web:ebd303b485c79845bbd7ba"),
    );
  } else {
    await Firebase.initializeApp(); // Initializing Firebase for other platforms
  }

  runApp(const HospitalityManagementApp()); // Running the app
}

class HospitalityManagementApp extends StatelessWidget {
  const HospitalityManagementApp({super.key}); // Constructor with key

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Using MultiProvider
      providers: [
        ChangeNotifierProvider(
            create: (_) => AppBarTitle()), // Providing AppBarTitle
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: RouteManager.loginPage,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppBarTitle with ChangeNotifier {
  String _title = ' Hospital\n Management App';  // Initial title of the app bar
  String get title => _title;  // Getter for the title

  void setTitle(String newTitle) {  // Method to update the title
    _title = newTitle;
    notifyListeners();  // Notify listeners about the title change
  }
}

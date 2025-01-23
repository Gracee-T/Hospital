import 'package:flutter/material.dart';


class EmailTextField extends StatelessWidget {
  final TextEditingController controller;  // Controller for email input
  final FormFieldValidator<String>? validator;  // Validator for form field

  const EmailTextField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),  // Padding around the text field
      child: TextFormField(
         cursorColor: Colors.white,
        controller: controller,  // Assigning controller to text field
        style: const TextStyle(fontWeight: FontWeight.bold),  // Setting text style
        decoration: InputDecoration(
          labelText: 'Please enter your email',  // Label text for the field
          labelStyle: const TextStyle(fontSize: 20, color: Colors.white),  // Label text style
          hintStyle: const TextStyle(color: Colors.grey),  // Hint text style
          prefixIcon: const Icon(Icons.email, color: Colors.grey),  // Prefix icon for the field
          errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),  // Error text style
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),  // Border style when enabled
            borderRadius: BorderRadius.circular(15.0),  // Border radius
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),  // Border style when focused
            borderRadius: BorderRadius.circular(15.0),  // Border radius
          ),
        ),
        validator: validator,  // Validator for the field
      ),
    );
  }
}


class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;  // Controller for password input
  final bool obscureText;  // Toggle for showing/hiding password
  final VoidCallback onSuffixIconPressed;  // Callback for suffix icon press
  final FormFieldValidator<String>? validator;  // Validator for form field

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onSuffixIconPressed,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),  // Padding around the text field
      child: TextFormField(
         cursorColor: Colors.white,
        controller: controller,  // Assigning controller to text field
        style: const TextStyle(fontWeight: FontWeight.bold),  // Setting text style
        decoration: InputDecoration(
          labelText: 'Please enter your password..',  // Label text for the field
          labelStyle: const TextStyle(fontSize: 20, color: Colors.white),  // Label text style
          hintStyle: const TextStyle(color: Colors.grey),  // Hint text style
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),  // Prefix icon for the field
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,  // Toggle icon for password visibility
              color: Colors.grey,
            ),
            onPressed: onSuffixIconPressed,  // Handling icon press
          ),
          errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),  // Error text style
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),  // Border style when enabled
            borderRadius: BorderRadius.circular(15.0),  // Border radius
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),  // Border style when focused
            borderRadius: BorderRadius.circular(15.0),  // Border radius
          ),
        ),
        obscureText: obscureText,  // Whether to obscure the text
        validator: validator,  // Validator for the field
      ),
    );
  }
}
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;  // Controller for custom input
  final String labelText;  // Label text for the field
  final IconData prefixIcon;  // Prefix icon for the field
  final bool obscureText;  // Toggle for showing/hiding text
  final FormFieldValidator<String>? validator;  // Validator for form field

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),  // Padding around the text field
      child: TextFormField(
        controller: controller,  // Assigning controller to text field
        style: const TextStyle(fontWeight: FontWeight.bold),  // Setting text style
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 20, color: Colors.white),  // Label text style
          hintStyle: const TextStyle(color: Colors.grey),  // Hint text style
          prefixIcon: Icon(prefixIcon, color: Colors.grey),  // Prefix icon for the field
          errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),  // Error text style
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),  // Border style when enabled
            borderRadius: BorderRadius.all(Radius.circular(8))    // Border radius
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 1.0),  // Border style when focused
            borderRadius: BorderRadius.all(Radius.circular(8))  // Border radius
          ),
          labelText: labelText,  // Setting label text
        ),
        obscureText: obscureText,  // Whether to obscure the text
        validator: validator,  // Validator for the field
      ),
    );
  }
}

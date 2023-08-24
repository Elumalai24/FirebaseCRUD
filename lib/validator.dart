import 'package:flutter/material.dart';

bool validateInputs(String name, String age, String phoneNumber, String email, BuildContext context) {
  if (name.isEmpty || age.isEmpty || phoneNumber.isEmpty || email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return false;
  }

  // You can add more advanced validation here if needed

  return true;
}
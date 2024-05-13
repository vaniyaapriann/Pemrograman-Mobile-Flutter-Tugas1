import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFields extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  
  const MyTextFields({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        focusedBorder: OutlineInputBorder(
           borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(
          color: Colors.grey.shade400,
          fontSize: 13,
          fontWeight: FontWeight.bold),
      ),
    );
  }
}
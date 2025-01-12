import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String name;
 final VoidCallback callback;

  const CustomButton({required this.name, super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(
            color:  Color(0xFF7C4DFF), 
            width: 2, 
          ),
          backgroundColor: const Color(0xFF7C4DFF), 
          foregroundColor: const Color(0xFF7C4DFF), 
          padding: const EdgeInsets.symmetric(
            vertical: 14, 
            horizontal: 24,
          ),
        ),
        onPressed: callback,
        child: Text(
          name,
          style: const TextStyle(
            color:Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

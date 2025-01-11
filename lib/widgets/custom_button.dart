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
            color: Colors.blue, 
            width: 2, 
          ),
          backgroundColor: Colors.blue, 
          foregroundColor: Colors.white, 
          padding: const EdgeInsets.symmetric(
            vertical: 14, 
            horizontal: 24,
          ),
        ),
        onPressed: callback,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

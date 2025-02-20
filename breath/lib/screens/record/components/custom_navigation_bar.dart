import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onClose;

  const CustomNavigationBar({
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: onBack,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

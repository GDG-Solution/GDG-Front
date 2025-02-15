import 'package:flutter/material.dart';

class PanicCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  PanicCard(
      {required this.title, required this.description, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: TextStyle(color: Colors.grey)),
                Icon(Icons.more_horiz),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

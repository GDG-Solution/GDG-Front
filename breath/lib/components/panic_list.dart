import 'package:flutter/material.dart';
import 'panic_card.dart';

class PanicList extends StatelessWidget {
  final List<Map<String, String>> panicRecords;

  PanicList({required this.panicRecords});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // 카드 높이 조정
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: panicRecords.length,
        itemBuilder: (context, index) {
          final record = panicRecords[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PanicCard(
              title: record['title']!,
              description: record['description']!,
              time: record['time']!,
            ),
          );
        },
      ),
    );
  }
}

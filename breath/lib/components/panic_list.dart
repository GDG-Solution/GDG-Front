import 'package:flutter/material.dart';
import 'panic_card.dart';

class PanicList extends StatelessWidget {
  final List<Map<String, String>> panicRecords;
  final PageController _pageController =
      PageController(viewportFraction: 0.8); // 카드 여러 개 보이게

  PanicList({required this.panicRecords});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360, // 카드 높이 조정
      child: PageView.builder(
        controller: _pageController,
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
              date: record['date']!,
              day: record['day']!,
              category: record['category']!,
            ),
          );
        },
      ),
    );
  }
}

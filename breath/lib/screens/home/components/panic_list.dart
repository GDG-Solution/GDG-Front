import 'package:flutter/material.dart';
import 'panic_card.dart';

class PanicList extends StatelessWidget {
  final List<Map<String, dynamic>> panicRecords; // ✅ dynamic으로 변경

  final PageController _pageController = PageController(viewportFraction: 0.8);

  PanicList({required this.panicRecords});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: panicRecords.length,
        itemBuilder: (context, index) {
          final record = panicRecords[index];
          double scale = 1.0;
          double opacity = 1.0;

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double page = _pageController.page ?? 0;

              if (page > index) {
                scale = 0.9;
                opacity = 0.5;
              } else if (page < index) {
                scale = 0.9;
                opacity = 0.5;
              } else {
                scale = 1.0;
                opacity = 1.0;
              }

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: PanicCard(
                      panicId: record["id"],
                      title: record['title'] as String? ?? "제목 없음", // ✅ 기본값 설정
                      description: record['content'] as String? ?? "내용 없음",
                      time: record['time'] as String? ?? "00:00",
                      date:
                          record['date']?.toString() ?? "N/A", // ✅ null-safe 처리
                      dateTime: record['dateTime']?.toString() ??
                          "N/A", // ✅ null-safe 처리
                      day: record['day'] as String? ?? "-",
                      category: List<String>.from(record['category'] ?? []),
                      painRate: record['score'] as int? ?? 0, // ✅ 0으로 설정
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'panic_card.dart';

class PanicList extends StatefulWidget {
  final List<Map<String, String>> panicRecords;

  PanicList({required this.panicRecords});

  @override
  _PanicListState createState() => _PanicListState();
}

class _PanicListState extends State<PanicList> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360, // 카드 높이 조정
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.panicRecords.length,
        itemBuilder: (context, index) {
          final record = widget.panicRecords[index];

          // 현재 선택된 카드면 불투명도 1.0, 나머지는 0.5 적용
          double opacity = (index - _currentPage).abs() < 0.5 ? 1.0 : 0.5;

          return Opacity(
            opacity: opacity, // ✅ 불투명도 적용
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PanicCard(
                  title: record['title']!,
                  description: record['description']!,
                  time: record['time']!,
                  date: record['date']!,
                  day: record['day']!,
                  category: record['category']!,
                  painRate: record['painRate']!),
            ),
          );
        },
      ),
    );
  }
}

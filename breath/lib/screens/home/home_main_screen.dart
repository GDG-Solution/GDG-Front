import 'package:flutter/material.dart';
import './components/category_filter.dart';
import './components/panic_list.dart';
import './components/custom_app_bar.dart';
import './components/monthly_panic_count.dart';

class HomeMainScreen extends StatelessWidget {
  final List<Map<String, String>> panicRecords = [
    {
      "title": "집에 혼자 있다가 생겼다",
      "description": "점점 공황이 약해지는 것 같다. 안전한 경험..",
      "time": "05:00",
      "date": "20",
      "day": "FRI",
      "category": "호흡곤란",
      "painRate": "5"
    },
    {
      "title": "사람 많은 곳에서 불안",
      "description": "주변 소음이 커질수록 심박수가 올라감",
      "time": "13:30",
      "date": "18",
      "day": "WED",
      "category": "숨 가쁨",
      "painRate": "3"
    },
  ];

  void _onCategoryChanged(String category) {
    print("선택된 카테고리: $category");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(), // ✅ 분리한 AppBar 사용
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF375E43), Color(0xFF3A413B)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            MonthlyPanicCount(count: panicRecords.length), // ✅ 공황 개수 표시 컴포넌트 사용
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: CategoryFilter(onCategorySelected: _onCategoryChanged),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 360,
                child: PanicList(panicRecords: panicRecords),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

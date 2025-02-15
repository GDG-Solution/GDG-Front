import 'package:flutter/material.dart';
import '../components/category_filter.dart';
import '../components/panic_list.dart';

class HomeMainScreen extends StatelessWidget {
  final List<Map<String, String>> panicRecords = [
    {
      "title": "집에 혼자 있다가 생겼다",
      "description": "점점 공황이 약해지는 것 같다. 안전한 경험..",
      "time": "05:00",
      "date": "20",
      "day": "FRI",
      "category": "호흡곤란"
    },
    {
      "title": "사람 많은 곳에서 불안",
      "description": "주변 소음이 커질수록 심박수가 올라감",
      "time": "13:30",
      "date": "18",
      "day": "WED",
      "category": "숨 가쁨"
    },
  ];

  void _onCategoryChanged(String category) {
    print("선택된 카테고리: $category");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 상단 네비게이션 뒤까지 배경 확장
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 투명 배경
        elevation: 0,
        title: Text(
          "이번 달에 이겨낸 나의 공황은",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // 공황 기록 추가 기능
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // 알림 기능
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF375E43), Color(0xFF3A413B)], // 배경 그라디언트
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100), // AppBar 투명처리 했으므로 여백 추가

            // 공황 개수 표시
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                  text: "이번 달에 이겨낸 나의 공황은 ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  children: [
                    TextSpan(
                      text: "1 개",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // 카테고리 필터
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: CategoryFilter(onCategorySelected: _onCategoryChanged),
            ),

            // 공황 기록 리스트 (슬라이드 가능)
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: panicRecords.length,
                itemBuilder: (context, index) {
                  final record = panicRecords[index];
                  return _buildPanicCard(record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 공황 기록 카드 디자인
  Widget _buildPanicCard(Map<String, String> record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 280,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 & 옵션 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(record['date']!,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(record['day']!,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Icon(Icons.more_horiz, color: Colors.black),
                ],
              ),
              SizedBox(height: 10),

              // 공황 유형 (예: 호흡곤란)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record['category']!,
                  style: TextStyle(fontSize: 12, color: Colors.green[700]),
                ),
              ),
              SizedBox(height: 8),

              // 제목
              Text(
                record['title']!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),

              // 설명
              Text(
                record['description']!,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 10),

              // 하단 시간 & 아이콘
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(record['time']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Icon(Icons.phone, color: Colors.grey[700], size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';
import '../../detail/detail_screen.dart'; // DetailScreen import 추가

class PanicCard extends StatelessWidget {
  final String panicId;
  final String title;
  final String description;
  final String time;
  final String date;
  final String day;
  final List<String> category;
  final int painRate;

  const PanicCard({
    required this.panicId,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.day,
    required this.category,
    required this.painRate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 카드 클릭 감지 추가
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(panicId: panicId), // DetailScreen으로 이동
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(day,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  PainLevelDots(
                    painRate: painRate,
                  ),
                ],
              ),
              SizedBox(height: 8),

              // 이미지 공간
              Container(
                width: double.infinity,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.image, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),

              // 카테고리 태그 리스트
              Wrap(
                spacing: 6.0, // 태그 간격
                runSpacing: 0,
                children: category.map((tag) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: Color(0xffE1F8CC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff275220)),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 6),

              // 제목
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 4),

              // 설명
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff626262),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),

              SizedBox(height: 8),

              // 시간 & 아이콘
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Icon(Icons.phone, color: Colors.grey[700], size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

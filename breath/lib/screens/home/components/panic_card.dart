import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';
import '../../detail/detail_screen.dart'; // DetailScreen import 추가

class PanicCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String date;
  final String day;
  final String category;
  final int painRate;

  const PanicCard({
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
            builder: (context) => DetailScreen(), // DetailScreen으로 이동
          ),
        );
      },
      child: Container(
        width: 140,
        height: 170,
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

              // 공황 유형 (예: 호흡곤란)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: Color(0xffE1F8CC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff275220)),
                ),
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

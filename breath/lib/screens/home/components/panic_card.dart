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

              // 카테고리 태그 리스트 (1줄만 표시 & 초과 개수 표현)
              _buildCategoryTags(),

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

              SizedBox(height: 14),

              // 시간 & 아이콘
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/icons/home/call_icon.png",
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 3.5),
                  Text(time,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTags() {
    List<Widget> tagWidgets = [];
    double currentWidth = 0.0;
    const double maxWidth = 200.0; // 최대 너비 설정 (적절히 조정 가능)

    for (String tag in category) {
      TextPainter painter = TextPainter(
        text: TextSpan(
          text: tag,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      double tagWidth = painter.width + 24; // 텍스트 폭 + 패딩 고려

      if (currentWidth + tagWidth > maxWidth) {
        int remainingCount = category.length - tagWidgets.length;
        if (remainingCount > 0) {
          tagWidgets.add(_buildTag("+ 외 $remainingCount 개"));
        }
        break;
      }

      tagWidgets.add(_buildTag(tag));
      currentWidth += tagWidth;
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 0,
      children: tagWidgets,
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: Color(0xffE1F8CC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff275220)),
      ),
    );
  }
}

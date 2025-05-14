import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';

class PanicLevelCard extends StatelessWidget {
  final String day; // 일
  final String time; // 공포수치
  final int level; // 공포수치

  const PanicLevelCard({
    Key? key,
    required this.day,
    required this.time,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x4DFFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                time, // 시간
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),

          SizedBox(width: 10),
          PainLevelDots(painRate: level), // 공포수치에 맞는 색상 점
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';

class PanicLevelCard extends StatelessWidget {
  final String month; // 월
  final String time; // 공포수치
  final int level; // 공포수치

  const PanicLevelCard({
    Key? key,
    required this.month,
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
        children: [
          Text(
            month,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(width: 10),
          PainLevelDots(painRate: level), // 공포수치에 맞는 색상 점
          SizedBox(width: 10),
          Text(
            time, // 시간
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// 나의 공포수치 변화 컴포넌트
class PanicLevelChanges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 369,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xAA3A413B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "나의 공포수치 변화",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          PanicLevelCard(month: "6월", time: "오후 13:00", level: 5),
          SizedBox(height: 10),
          PanicLevelCard(month: "5월", time: "오후 13:00", level: 4),
          SizedBox(height: 10),
          PanicLevelCard(month: "1월", time: "오후 13:00", level: 3),
        ],
      ),
    );
  }
}

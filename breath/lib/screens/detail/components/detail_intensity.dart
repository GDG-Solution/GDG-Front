import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';

class DetailIntensity extends StatelessWidget {
  final int intensity; // 공포 수치 (0~5)

  const DetailIntensity({Key? key, required this.intensity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // 내부 여백
      decoration: BoxDecoration(
        color: Colors.green[800], // 배경색
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "공포 수치",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(width: 10),
          PainLevelDots(painRate: intensity), // 공용 공포 수치 컴포넌트 사용
        ],
      ),
    );
  }
}

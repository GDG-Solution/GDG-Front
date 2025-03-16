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
        color: Color(0x1A000000), // 배경색
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "공포 수치",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC3D1B8)),
          ),
          const SizedBox(width: 12),
          PainLevelDots(painRate: intensity), // 공용 공포 수치 컴포넌트 사용
        ],
      ),
    );
  }
}

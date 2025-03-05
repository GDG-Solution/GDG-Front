import 'package:flutter/material.dart';

class PainLevelDots extends StatelessWidget {
  final int painRate;

  const PainLevelDots({Key? key, required this.painRate}) : super(key: key);

  // painRate에 따른 색상 자동 매핑
  static const Map<int, Color> painColors = {
    5: Color(0xFFFF6224), // 매우 강함 (빨강)
    4: Color(0xFFFF800A), // 강함 (주황)
    3: Color(0xFFFFBD24), // 중간 (노랑)
    2: Color(0xFFF6DD96), // 약함 (연한 노랑)
  };

  @override
  Widget build(BuildContext context) {
    Color dotColor = painColors[painRate] ?? Colors.grey; // 기본값: 회색

    return Row(
      children: [
        ...List.generate(
          5 - painRate,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 4), // padding 명시적으로 지정
            child: Icon(Icons.circle, color: Colors.grey, size: 10),
          ),
        ),
        ...List.generate(
          painRate,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 4), // padding 명시적으로 지정
            child: Icon(Icons.circle, color: dotColor, size: 10),
          ),
        ),
      ],
    );
  }
}

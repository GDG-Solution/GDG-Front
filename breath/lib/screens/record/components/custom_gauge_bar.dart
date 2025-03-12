import 'package:flutter/material.dart';

class CustomGaugeBar extends StatelessWidget {
  final int maxValue; // 최대 값 (기본값: 6)
  final int currentValue; // 현재 값 (0~6)
  final double height; // 게이지 높이
  final Color fillColor; // 채워진 부분 색상
  final Color backgroundColor; // 배경 색상

  const CustomGaugeBar({
    Key? key,
    this.maxValue = 6, // 기본 최대값 6
    required this.currentValue,
    this.height = 20,
    this.fillColor = Colors.green,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 게이지 비율 계산
    double fillPercentage = (currentValue / maxValue).clamp(0.0, 1.0);

    return Container(
      width: double.infinity, // 가로 전체 너비
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2), // 둥근 모서리
      ),
      child: Stack(
        children: [
          // 채워진 부분
          FractionallySizedBox(
            widthFactor: fillPercentage,
            child: Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(height / 2), // 둥근 모서리 유지
              ),
            ),
          ),
        ],
      ),
    );
  }
}

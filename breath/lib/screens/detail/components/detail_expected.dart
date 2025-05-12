import 'package:flutter/material.dart';

class DetailExpected extends StatelessWidget {
  final bool expected; // 예상 여부를 받기 위한 변수

  const DetailExpected({Key? key, required this.expected}) : super(key: key);

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
          Text(
            // 예상 여부 표시
            "예상 여부",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC3D1B8)),
          ),
          const SizedBox(width: 12),
          Text(
            expected ? "O" : "X",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

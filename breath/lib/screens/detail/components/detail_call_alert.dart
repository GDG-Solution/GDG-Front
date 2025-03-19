import 'package:flutter/material.dart';

class DetailCallAlert extends StatelessWidget {
  final int callDurationSeconds;

  const DetailCallAlert({Key? key, required this.callDurationSeconds})
      : super(key: key);

  // 초를 "MM:SS" 형식으로 변환하는 함수
  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // 위아래 여백 추가
      decoration: BoxDecoration(
        color: Color(0xFFE1F8CC), // 밝은 초록색 배경
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 전화 아이콘
          Icon(
            Icons.call,
            color: Color(0xFF275220), // 어두운 초록색
            size: 20,
          ),
          const SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
          // "평소보다 통화 시간이 길어요" 텍스트
          Expanded(
            child: Text(
              "평소보다 통화 시간이 길어요",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF275220),
                fontSize: 14,
              ),
            ),
          ),
          // 변환된 통화 시간
          Text(
            formatDuration(callDurationSeconds),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF275220),
            ),
          ),
        ],
      ),
    );
  }
}

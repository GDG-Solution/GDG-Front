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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.green),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "평소보다 통화 시간이 길어요",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            formatDuration(callDurationSeconds), // 변환된 통화 시간 출력
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:breath/screens/conversation/conversation_screen.dart';

class DetailCallAlert extends StatelessWidget {
  final int callDurationSeconds;

  const DetailCallAlert({Key? key, required this.callDurationSeconds})
      : super(key: key);

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(), // ✅ 여기로 이동
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFFE1F8CC),
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
            Icon(
              Icons.call,
              color: Color(0xFF275220),
              size: 20,
            ),
            const SizedBox(width: 10),
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
      ),
    );
  }
}

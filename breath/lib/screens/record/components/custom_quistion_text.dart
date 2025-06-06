import 'package:flutter/material.dart';

class CustomQuestionCard extends StatelessWidget {
  final int questionNumber;
  final String question;
  final String subText;

  CustomQuestionCard({
    required this.questionNumber,
    required this.question,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // ✅ 질문 텍스트와 번호 정렬
      children: [
        // // ✅ 질문 번호 원형 박스
        // Container(
        //   width: 34,
        //   height: 34,
        //   decoration: BoxDecoration(
        //     color: Color(0xFFF3FCE7),
        //     shape: BoxShape.circle,
        //   ),
        //   alignment: Alignment.center,
        //   child: Text(
        //     questionNumber,
        //     style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w700,
        //       color: Color(0xFF6EE95C),
        //     ),
        //   ),
        // ),
        // SizedBox(width: 14),

        // ✅ 질문 텍스트
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff275220),
                ),
              ),
              SizedBox(height: 4),
              Text(
                subText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff728C78),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

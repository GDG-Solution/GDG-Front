import 'package:flutter/material.dart';

class CustomMessageBox extends StatelessWidget {
  final String message;

  const CustomMessageBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72, // 버튼 스타일처럼 만들기
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 35), // 좌우 여백 추가
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        border: Border.all(
          color: Colors.white.withOpacity(0.5), // 반투명한 테두리
          width: 1.5, // 테두리 두께
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        message, // 전달된 메시지 사용
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

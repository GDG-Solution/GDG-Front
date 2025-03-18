import 'package:flutter/material.dart';

class CustomMessageBox extends StatelessWidget {
  final String message;

  const CustomMessageBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10), // 상하좌우 10의 패딩 추가
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 25), // 좌우 여백 추가
        padding: EdgeInsets.all(10), // 내부 패딩 추가
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20), // 둥근 모서리
          border: Border.all(
            color: Colors.white.withOpacity(0.5), // 반투명한 테두리
            width: 1.5, // 테두리 두께
          ),
        ),
        child: Text(
          message, // 전달된 메시지 사용
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

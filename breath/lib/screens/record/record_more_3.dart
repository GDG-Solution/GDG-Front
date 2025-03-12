// Q3. 상황적기.

import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_quistion_text.dart';

class RecordPage3 extends StatefulWidget {
  @override
  _RecordPage3State createState() => _RecordPage3State();
}

class _RecordPage3State extends State<RecordPage3> {
  TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 네비게이션 바 추가
            CustomNavigationBar(
              onBack: () {
                Navigator.pop(context);
              },
              onClose: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),

            SizedBox(height: 10), // 네비게이션 바 아래 여백 추가

            // ✅ 질문 카드
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomQuestionCard(
                    questionNumber: 3,
                    question: "공황이 일어난 이유는 무엇인가요",
                    subText: "이유를 알면 두려움이 줄어들어요",
                  ),

                  SizedBox(height: 20),

                  // ✅ 입력 필드 추가
                  TextField(
                    controller: _inputController,
                    onChanged: (value) {
                      print("사용자 입력: $value");
                    },
                    decoration: InputDecoration(
                      hintText: "여기에 입력해주세요.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF3F3F3),
                    ),
                    maxLines: 4,
                  )
                ],
              ),
            ),

            Spacer(), // 남은 공간 차지하여 하단 버튼 고정

            // ✅ 하단 버튼 추가 (CustomButton 사용)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "건너뛰기",
                    width: 88,
                    bgColor: Color(0xFFDBE3D0),
                    textColor: Color(0xff728C78),
                    borderColor: Color(0xffCBE0B8),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage3(),
                        ),
                      );
                    },
                  ),
                  CustomButton(
                    text: "다음",
                    width: 272,
                    bgColor: Color(0xFFE1F8CC),
                    textColor: Color(0xFF275220),
                    borderColor: Color(0xffCBE0B8),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage3(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

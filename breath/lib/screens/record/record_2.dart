import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';

import './record_3.dart';
import 'components/custom_quistion_text.dart';

class RecordPage2 extends StatefulWidget {
  final int painRate;

  RecordPage2({required this.painRate});

  @override
  _RecordPage2State createState() => _RecordPage2State();
}

class _RecordPage2State extends State<RecordPage2> {
  @override
  Widget build(BuildContext context) {
    print("전달받은 painRate: ${widget.painRate}"); // ✅ 콘솔 출력 추가
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 네비게이션 바
            CustomNavigationBar(
              onBack: () {
                Navigator.pop(context);
              },
              onClose: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),

            // ✅ 제목
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                // ✅ Align 추가하여 좌측 정렬 강제
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "구체적인 기록을 위해\n4 가지 질문에 답해주세요",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff275220),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ✅ 질문 카드
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomQuestionCard(
                    questionNumber: "Q1",
                    question: "공황이 일어났던 주변을 찍어주세요",
                    subText: "찍기 어렵다면 패스해도 좋아요",
                  ),

                  SizedBox(height: 20),

                  // ✅ 카메라 박스
                  GestureDetector(
                    onTap: () {
                      print("카메라 열기");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text(
                            "주변 배경을 찍어주세요",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff626262),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // ✅ 하단 버튼 (CustomButton 활용)
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

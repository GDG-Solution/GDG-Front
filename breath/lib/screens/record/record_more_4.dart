import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';

import 'components/custom_gauge_bar.dart';
import 'record_more_5.dart';

class RecordPage4 extends StatefulWidget {
  @override
  _RecordPage4State createState() => _RecordPage4State();
}

class _RecordPage4State extends State<RecordPage4> {
  @override
  Widget build(BuildContext context) {
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

            CustomGaugeBar(
              currentValue: 5, // ✅ 현재 값 (0~6)
            ),

            SizedBox(height: 38),

            // ✅ 상단 메시지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "마지막 질문이에요",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff728C78),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "오늘의 공황은 예상하셨나요?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff275220),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 70),

            Container(
              height: 231,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/record/record_ox.png"),
                  fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 채워지도록 설정
                ),
              ),
            ),

            Spacer(),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "예상했어요",
                    width: 170,
                    bgColor: Color(0xFFFFFFFF).withOpacity(0.5),
                    textColor: Color(0xff275220),
                    borderColor: Color(0xffE1F8CC),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage5(),
                        ),
                      );
                    },
                  ),
                  CustomButton(
                    text: "예상 못했어요",
                    width: 170,
                    bgColor: Color(0xFFFFFFFF).withOpacity(0.5),
                    textColor: Color(0xff275220),
                    borderColor: Color(0xffE1F8CC),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage5(),
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

import 'package:flutter/material.dart';
import 'record_more_1.dart';
import './components/custom_button.dart';
import './components/pain_level_selector.dart';

class RecordMain extends StatefulWidget {
  @override
  _RecordMainState createState() => _RecordMainState();
}

class _RecordMainState extends State<RecordMain> {
  int _painRate = -1; // ✅ 선택된 인덱스 (-1: 아무것도 선택되지 않음)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),

            // ✅ 상단 메시지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/record/leaf_left.png", width: 37),
                SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      "오늘도 이겨냈어요!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff275220),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "분석을 위해 고통 수치를 선택해주세요",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff728C78),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Image.asset("assets/images/record/leaf_right.png", width: 37),
              ],
            ),

            SizedBox(height: 67),

            // ✅ 캐릭터 박스
            Container(
              width: 137,
              height: 92,
              color: Colors.grey[400],
              alignment: Alignment.center,
              child: Text("캐릭터"),
            ),

            // ✅ 선택 리스트 (컴포넌트 사용)
            PainLevelSelector(
              onSelected: (painRate) {
                setState(() {
                  _painRate = painRate;
                });
              },
            ),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "안하기",
                    width: 88,
                    bgColor: Color(0xFFDBE3D0),
                    textColor: Color(0xff728C78),
                    borderColor: Color(0xffCBE0B8),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                  CustomButton(
                    text: "기록하기",
                    width: 272,
                    bgColor: Color(0xFFE1F8CC),
                    textColor: Color(0xFF275220),
                    borderColor: Color(0xffCBE0B8),
                    onPressed: () {
                      if (_painRate != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecordPage2(painRate: 5 - _painRate),
                          ),
                        );
                      }
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

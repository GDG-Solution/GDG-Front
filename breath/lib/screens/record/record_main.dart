// Q0. 오늘도 이겨냈어요! 고통 수치 기록

import 'package:flutter/material.dart';
import 'record_more_1.dart';
import './components/custom_button.dart';

class RecordMain extends StatefulWidget {
  @override
  _RecordMainState createState() => _RecordMainState();
}

class _RecordMainState extends State<RecordMain> {
  int _painRate = -1; // ✅ 선택된 인덱스 (-1: 아무것도 선택되지 않음)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7), // ✅ 배경색 적용
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

            // ✅ 선택 리스트
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildOption(0, "매우 강함", Color(0xFFFF6224), 5),
                  _buildOption(1, "강함", Color(0xFFFF800A), 4),
                  _buildOption(2, "중간", Color(0xFFFFBD24), 3),
                  _buildOption(3, "약함", Color(0xFFF6DD96), 2),
                ],
              ),
            ),

            // ✅ 하단 버튼 (CustomButton 사용)
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

  // ✅ 옵션 리스트 아이템
  Widget _buildOption(int index, String label, Color dotColor, int dotCount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _painRate = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
            color: _painRate == index ? Colors.white : Color(0xFFF9FEF3),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              )
            ]),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              color: Colors.grey[400],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      5 - dotCount,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.circle, color: Colors.grey, size: 10),
                      ),
                    ),
                    ...List.generate(
                      dotCount,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.circle, color: dotColor, size: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff275220)),
                ),
              ],
            ),
            Spacer(),
            Icon(
              _painRate == index
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _painRate == index ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

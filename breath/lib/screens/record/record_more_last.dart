import 'package:flutter/material.dart';
import './components/custom_button.dart';

class RecordPage5 extends StatefulWidget {
  @override
  _RecordPage5State createState() => _RecordPage5State();
}

class _RecordPage5State extends State<RecordPage5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: SafeArea(
        child: Column(
          children: [
            // // ✅ 네비게이션 바
            // CustomNavigationBar(
            //   onBack: () {
            //     Navigator.pop(context);
            //   },
            //   onClose: () {
            //     Navigator.of(context).popUntil((route) => route.isFirst);
            //   },
            // ),

            SizedBox(height: 38),

            // ✅ 상단 메시지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "좋아요!\n정확한 기록을 끝냈어요",
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

            // Container(
            //   height: 231,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage("assets/images/record/record_ox.png"),
            //       fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 채워지도록 설정
            //     ),
            //   ),
            // ),

            Spacer(),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "오늘도 성공",
                    width: 365,
                    bgColor: Color(0xFFE1F8CC),
                    textColor: Color(0xff275220),
                    borderColor: Color(0xff0000001A),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
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

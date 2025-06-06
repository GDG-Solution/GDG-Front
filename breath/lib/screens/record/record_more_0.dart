import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';

import 'components/custom_gauge_bar.dart';
import 'record_more_1.dart';

class RecordPage0 extends StatefulWidget {
  final String counselId;
  final int painRate;

  RecordPage0({required this.painRate, required this.counselId});

  @override
  _RecordPage0State createState() => _RecordPage0State();
}

class _RecordPage0State extends State<RecordPage0> {
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
              currentValue: 1,
            ),

            SizedBox(height: 38),

            // ✅ 내용은 스크롤이 가능하도록 처리
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // ✅ 상단 메시지
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "분석을 위해\n더 정확한 기록이 필요해요",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff275220),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "기록하면 트로피를 드려요",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff728C78),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 70),

                    // ✅ 이미지
                    Container(
                      width: 259.53,
                      height: 264,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/record/record_medal.png"),
                          fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 채워지도록 설정
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "안하기",
                      width: 88,
                      bgColor: Color(0xFFDBE3D0),
                      textColor: Color(0xff728C78),
                      borderColor: Color(0xffCBE0B8),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                  SizedBox(width: 10), // 버튼 사이의 간격 추가
                  Expanded(
                    child: CustomButton(
                      text: "기록하기",
                      width: 272,
                      bgColor: Color(0xFFE1F8CC),
                      textColor: Color(0xFF275220),
                      borderColor: Color(0xffCBE0B8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecordPage1(
                              counselId: widget.counselId,
                              painRate: widget.painRate,
                            ),
                          ),
                        );
                      },
                    ),
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

import 'dart:io'; // File 객체 사용을 위해 추가
import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_gauge_bar.dart';
import 'record_more_loading.dart';

class RecordPage4 extends StatefulWidget {
  final String counselId;
  final int painRate;
  final File? imageFile;
  final List<String> selectedSymptoms;
  final String panicReason; // 공황 이유 추가
  final String title;

  RecordPage4({
    required this.counselId,
    required this.painRate,
    this.imageFile,
    required this.selectedSymptoms,
    required this.panicReason,
    required this.title,
  });

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
            CustomNavigationBar(
              onBack: () {
                Navigator.pop(context);
              },
              onClose: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),

            CustomGaugeBar(
              currentValue: 5,
            ),

            SizedBox(height: 38),

            // ✅ 기존 메시지 유지
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

            SizedBox(height: 20),

            Container(
              height: 231,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/record/record_ox.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Spacer(),

            // ✅ 기존 버튼 유지
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
                          builder: (context) => RecordLoadingPage(
                            counselId: widget.counselId,
                            painRate: widget.painRate,
                            imageFile: widget.imageFile,
                            selectedSymptoms: widget.selectedSymptoms,
                            title: widget.title,
                            panicReason: widget.panicReason,
                            expectation: true,
                          ),
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
                          builder: (context) => RecordLoadingPage(
                            counselId: widget.counselId,
                            painRate: widget.painRate,
                            imageFile: widget.imageFile,
                            selectedSymptoms: widget.selectedSymptoms,
                            title: widget.title,
                            panicReason: widget.panicReason,
                            expectation: false,
                          ),
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

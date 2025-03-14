import 'dart:io';
import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_gauge_bar.dart';
import 'components/custom_quistion_text.dart';
import 'record_more_4.dart';

class RecordPage3 extends StatefulWidget {
  final int painRate;
  final File? imageFile;
  final List<String> selectedSymptoms; // 증상 리스트 추가

  RecordPage3({
    required this.painRate,
    this.imageFile,
    required this.selectedSymptoms, // 생성자에서 받아오기
  });

  @override
  _RecordPage3State createState() => _RecordPage3State();
}

class _RecordPage3State extends State<RecordPage3> {
  TextEditingController _inputController = TextEditingController();
  bool nextButtonEnabled = false; // 버튼 활성화 상태

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _inputController.removeListener(_updateButtonState);
    _inputController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      nextButtonEnabled = _inputController.text.trim().isNotEmpty; // 입력 여부 확인
    });
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

            CustomGaugeBar(
              currentValue: 4,
            ),

            SizedBox(height: 28),

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
                    decoration: InputDecoration(
                      hintText: "여기에 입력해주세요.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF3F3F3),
                    ),
                    maxLines: 4,
                  ),
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
                    text: "다음",
                    width: 365,
                    bgColor: nextButtonEnabled
                        ? Color(0xFFE1F8CC).withOpacity(0.9) // 입력값 있으면 활성화
                        : Colors.black.withOpacity(0.1), // 입력 없으면 비활성화 색상
                    textColor: nextButtonEnabled
                        ? Color(0xFF275220)
                        : Color(0xffA1A1A1),
                    borderColor: nextButtonEnabled
                        ? Color(0xffCBE0B8)
                        : Colors.black.withOpacity(0.1),
                    onPressed: nextButtonEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecordPage4(
                                  painRate: widget.painRate, // 기존 데이터 유지
                                  imageFile: widget.imageFile, // 기존 데이터 유지
                                  selectedSymptoms:
                                      widget.selectedSymptoms, // 기존 데이터 유지
                                  panicReason:
                                      _inputController.text.trim(), // 공황 이유 전달
                                ),
                              ),
                            );
                          }
                        : () {}, // ✅ 입력 없으면 버튼 비활성화
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

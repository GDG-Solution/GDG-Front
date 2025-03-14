import 'dart:io';
import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';

import 'components/custom_gauge_bar.dart';
import 'components/custom_quistion_text.dart';
import 'record_more_3.dart';

class RecordPage2 extends StatefulWidget {
  final int painRate;
  final File? imageFile; // RecordPage1에서 전달받은 사진 파일

  RecordPage2({required this.painRate, this.imageFile}); // 생성자 변경

  @override
  _RecordPage2State createState() => _RecordPage2State();
}

class _RecordPage2State extends State<RecordPage2> {
  List<String> selectedSymptoms = [];
  bool nextButtonEnabled = false; // 버튼 활성화 상태

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
      nextButtonEnabled = selectedSymptoms.isNotEmpty; // 증상이 선택되었는지 확인
    });
  }

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
            CustomGaugeBar(currentValue: 3),
            SizedBox(height: 28),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomQuestionCard(
                    questionNumber: 2,
                    question: "증상을 모두 선택해주세요",
                    subText: "약한 증상도 선택해주세요",
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: symptomList.map((symptom) {
                      bool isSelected = selectedSymptoms.contains(symptom);
                      return GestureDetector(
                        onTap: () => _toggleSymptom(symptom),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFFFFFFF)
                                : Color(0xffF9FEF3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFE1F8CC),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            symptom,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Color(0xFF275220)
                                  : Color(0xFF728C78),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                      text: "다음",
                      width: 365,
                      bgColor: nextButtonEnabled
                          ? Color(0xFFE1F8CC)
                          : Colors.black.withOpacity(0.1),
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
                                  builder: (context) => RecordPage3(
                                    painRate: widget.painRate, // 기존 데이터 유지
                                    imageFile: widget.imageFile, // 기존 데이터 유지
                                    selectedSymptoms:
                                        selectedSymptoms, // 증상 리스트 전달
                                  ),
                                ),
                              );
                            }
                          : () {}), // 버튼 비활성화
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 증상 리스트
  final List<String> symptomList = [
    "가슴통증",
    "호흡곤란",
    "복통",
    "구역질",
    "비현실감",
    "열감/오한",
    "떨림",
    "어지러움",
    "두근거림",
    "죽음에 대한 공포"
  ];
}

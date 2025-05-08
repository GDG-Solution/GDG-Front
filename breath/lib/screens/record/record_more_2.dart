import 'dart:io';
import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';

import 'components/custom_gauge_bar.dart';
import 'components/custom_quistion_text.dart';
import 'record_more_3.dart';

class RecordPage2 extends StatefulWidget {
  final String counselId;
  final int painRate;
  final File? imageFile; // RecordPage1에서 전달받은 사진 파일

  RecordPage2({
    required this.counselId,
    required this.painRate,
    this.imageFile,
  }); // 생성자 변경

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
                  Column(
                    children: List.generate(symptomList.length, (index) {
                      final symptom = symptomList[index];
                      final bool isSelected =
                          selectedSymptoms.contains(symptom);
                      return GestureDetector(
                        onTap: () => _toggleSymptom(symptom),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12), // 항목 간 간격
                          padding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 32),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFFFFFFF)
                                : Color(0xFFF9FEF3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFF90DD85)
                                  : Color(0xFFE1F8CC),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
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
                              if (isSelected)
                                Icon(Icons.check,
                                    color: Color(0xFF275220), size: 20),
                            ],
                          ),
                        ),
                      );
                    }),
                  )
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
                                    counselId: widget.counselId,
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
    "죽음에 대한 공포",
    "가슴통증",
    "호흡곤란",
    "복통",
    "비현실감",
    "열감/오한",
    "떨림",
    "어지러움",
    "두근거림",
    "피로감",
    "불안감",
  ];
}

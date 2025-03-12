// Q2. 증상을 모두 선택해주세요. 증상 선택

import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_quistion_text.dart';

import 'record_more_3.dart';

class RecordPage2 extends StatefulWidget {
  @override
  _RecordPage2State createState() => _RecordPage2State();
}

class _RecordPage2State extends State<RecordPage2> {
  // ✅ 선택된 증상 관리
  List<String> selectedSymptoms = [];

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

            SizedBox(height: 10), // 네비게이션 바 아래 여백 추가

            // ✅ 질문 카드
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

                  // ✅ 증상 선택 리스트
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: symptomList.map((symptom) {
                      bool isSelected = selectedSymptoms.contains(symptom);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedSymptoms.remove(symptom);
                            } else {
                              selectedSymptoms.add(symptom);
                            }
                          });
                        },
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

            Spacer(), // 남은 공간 차지하여 하단 버튼 고정

            // ✅ 하단 버튼 추가 (CustomButton 사용)
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

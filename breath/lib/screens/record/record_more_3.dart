import 'dart:io';
import 'package:flutter/material.dart';
import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_gauge_bar.dart';
import 'components/custom_quistion_text.dart';
import 'record_more_4.dart';

class RecordPage3 extends StatefulWidget {
  final String counselId;
  final int painRate;
  final File? imageFile;
  final List<String> selectedSymptoms; // 증상 리스트 추가

  RecordPage3({
    required this.counselId,
    required this.painRate,
    this.imageFile,
    required this.selectedSymptoms, // 생성자에서 받아오기
  });

  @override
  _RecordPage3State createState() => _RecordPage3State();
}

class _RecordPage3State extends State<RecordPage3> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool nextButtonEnabled = false; // 버튼 활성화 상태

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateButtonState);
    _contentController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateButtonState);
    _contentController.removeListener(_updateButtonState);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      nextButtonEnabled = _titleController.text.trim().isNotEmpty &&
          _contentController.text.trim().isNotEmpty;
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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

                          // 제목 TextField
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: "제목을 적어주세요",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Color(0xFF90DD85), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Color(0xFF90DD85), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Color(0xFF98D87A), width: 2),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFFFF),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            maxLines: 1,
                          ),

                          SizedBox(height: 16),

                          // 내용 TextField + 글자 수
                          Stack(
                            children: [
                              TextField(
                                controller: _contentController,
                                maxLength: 100,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: "ex) 거리에 갑자기 사람들이 많아지니까 머리가 너무 아팠어",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: Color(0xFF90DD85), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: Color(0xFF90DD85), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: Color(0xFF98D87A), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  counterText: "", // 하단 기본 카운터 숨기기
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 12,
                                child: Text(
                                  "${_contentController.text.length}/100",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                                  counselId: widget.counselId,
                                  painRate: widget.painRate, // 기존 데이터 유지
                                  imageFile: widget.imageFile, // 기존 데이터 유지
                                  selectedSymptoms:
                                      widget.selectedSymptoms, // 기존 데이터 유지
                                  title:
                                      _titleController.text.trim(), // 공황 이유 전달
                                  panicReason: _contentController.text
                                      .trim(), // 공황 이유 전달
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

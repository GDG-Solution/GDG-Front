import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import './components/custom_button.dart';
import './components/custom_navigation_bar.dart';
import 'components/custom_gauge_bar.dart';
import 'record_more_2.dart';
import 'components/custom_quistion_text.dart';

class RecordPage1 extends StatefulWidget {
  final String counselId;
  final int painRate;

  RecordPage1({
    required this.counselId,
    required this.painRate,
  });

  @override
  _RecordPage1State createState() => _RecordPage1State();
}

class _RecordPage1State extends State<RecordPage1> {
  File? _image;
  final picker = ImagePicker();

  // ✅ 이미지 리사이징 함수
  Future<File> resizeImage(File file) async {
    final bytes = await file.readAsBytes();
    final original = img.decodeImage(bytes);

    final resized = img.copyResize(original!, width: 800);
    final resizedBytes = img.encodeJpg(resized, quality: 80);

    final tempDir = Directory.systemTemp;
    final resizedFile = File('${tempDir.path}/resized_image.jpg');
    return await resizedFile.writeAsBytes(resizedBytes);
  }

  // ✅ 카메라 실행 함수
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final originalFile = File(pickedFile.path);
      final resizedFile = await resizeImage(originalFile); // ✅ 압축 적용

      setState(() {
        _image = resizedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: SafeArea(
        child: Column(
          children: [
            CustomNavigationBar(
              onBack: () => Navigator.pop(context),
              onClose: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
            CustomGaugeBar(currentValue: 2),
            SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomQuestionCard(
                            questionNumber: 1,
                            question: "공황이 일어난 환경을 기록해보세요",
                            subText: "찍기 어렵다면 패스해도 좋아요",
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Color(0xFFE1F8CC),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _image == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.camera_alt,
                                            color: Color(0xff428C37), size: 40),
                                        SizedBox(height: 8),
                                        Text(
                                          "이곳을 터치해서 사진을 찍어봐",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff428C37),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.file(
                                        _image!,
                                        width: double.infinity,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              "assets/images/record/record_camera.png",
                              width: 157,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: "다음",
                    width: 365,
                    bgColor: Color(0xFFE1F8CC),
                    textColor: Color(0xFF275220),
                    borderColor: Color(0xffCBE0B8),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordPage2(
                            counselId: widget.counselId,
                            painRate: widget.painRate,
                            imageFile: _image,
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

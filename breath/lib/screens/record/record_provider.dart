import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecordProvider with ChangeNotifier {
  int painRate = -1; // 고통 수치
  List<String> symptoms = []; // 증상 리스트
  String panicTitle = ""; // 제목
  String panicContent = ""; // 내용
  List<String> picturePaths = []; // 사진 경로

  // ✅ 고통 수치 저장
  void setPainRate(int rate) {
    painRate = rate;
    notifyListeners();
    print('[Provider] 고통 수치 저장됨');
  }

  // ✅ 증상 선택 추가/삭제
  void toggleSymptom(String symptom) {
    if (symptoms.contains(symptom)) {
      symptoms.remove(symptom);
    } else {
      symptoms.add(symptom);
    }
    notifyListeners();
    print('[Provider] 증상 선택 추가/삭제됨');
  }

  // ✅ 사진 추가 메서드 (이거 없어서 오류 났음)
  void addPicture(String path) {
    picturePaths.add(path);
    notifyListeners();
    print('[Provider] 사진 추가됨');
  }

  // ✅ 사진 삭제 메서드
  void removePicture(String path) {
    picturePaths.remove(path);
    notifyListeners();
    print('[Provider] 사진 삭제됨');
  }

  // ✅ 공황 발생 이유(사용자 입력) 저장
  void setPanicReason(String reason) {
    panicTitle = reason;
    notifyListeners();
    print('[Provider] 공황 발생 이유 저장됨');
  }

  // ✅ 제목과 내용 저장
  void setPanicInfo(String title, String content) {
    panicTitle = title;
    panicContent = content;
    notifyListeners();
    print('[Provider] 제목과 내용 저장됨');
  }

  // ✅ 최종 JSON 변환
  Map<String, dynamic> toJson() {
    return {
      "score": painRate,
      "category": symptoms,
      "title": panicTitle,
      "content": panicContent,
      "picture": picturePaths,
    };
  }

  // ✅ API 요청 (POST)
  Future<void> submitRecord(BuildContext context) async {
    final String baseUrl = dotenv.env['BASE_URL'] ?? ""; // 환경 변수에서 URL 가져오기
    final String url = "$baseUrl/diary"; // 백엔드 API 엔드포인트

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(toJson()), // JSON 변환 후 요청
      );

      if (response.statusCode == 201) {
        print("✅ 데이터 전송 성공!");
        _showSuccessDialog(context); // ✅ 성공 시 다이얼로그 표시
      } else {
        print("❌ 데이터 전송 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API 요청 오류: $e");
    }
  }

// ✅ 성공 다이얼로그 표시
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("기록 완료"),
          content: Text("오늘의 기록이 성공적으로 저장되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }
}

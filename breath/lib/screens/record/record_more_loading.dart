import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'record_more_last.dart'; // 완료 페이지

class RecordLoadingPage extends StatefulWidget {
  final int painRate;
  final File? imageFile;
  final List<String> selectedSymptoms;
  final String panicReason;
  final String expectation;

  RecordLoadingPage({
    required this.painRate,
    this.imageFile,
    required this.selectedSymptoms,
    required this.panicReason,
    required this.expectation,
  });

  @override
  _RecordLoadingPageState createState() => _RecordLoadingPageState();
}

class _RecordLoadingPageState extends State<RecordLoadingPage> {
  bool _isLoading = true;
  String? _errorMessage;

  String _userId = "";

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('id') ?? "Unknown ID";
    });
  }

  @override
  void initState() {
    super.initState();
    _sendDataToServer();
    _loadUserInfo(); // 저장된 사용자 정보 불러오기
  }

  // ✅ 서버에 데이터 전송하는 함수
  Future<void> _sendDataToServer() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
    if (baseUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 URL이 설정되지 않았습니다.";
      });
      return;
    }

    try {
      // ✅ 요청 데이터 준비
      Map<String, dynamic> requestData = {
        "userId": _userId,
        "counselId": "67d2de46670a6a368def835b",
        "picture": widget.imageFile != null
            ? await _convertImageToBase64(widget.imageFile!)
            : null,
        "category": widget.selectedSymptoms,
        "score": widget.painRate,
        "title": widget.expectation,
        "content": widget.panicReason,
      };

      // ✅ POST 요청 보내기
      final response = await http.post(
        Uri.parse("$baseUrl/diary"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        // ✅ 성공 시 완료 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecordPage5()),
        );
      } else {
        // ❌ 실패 시 오류 메시지 표시
        setState(() {
          _isLoading = false;
          _errorMessage = "서버 응답 오류: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 요청 실패: $e";
      });
    }
  }

  // ✅ 이미지를 Base64로 변환하는 함수
  Future<String> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7),
      body: Center(
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF275220)),
                  SizedBox(height: 20),
                  Text(
                    "기록을 저장하는 중...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "⚠️ 오류 발생",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(_errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("돌아가기"),
                  ),
                ],
              ),
      ),
    );
  }
}

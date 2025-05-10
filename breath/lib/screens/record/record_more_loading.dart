import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'record_more_last.dart';
import 'package:http_parser/http_parser.dart';

class RecordLoadingPage extends StatefulWidget {
  final String counselId;
  final int painRate;
  final File? imageFile;
  final List<String> selectedSymptoms;
  final String title;
  final String panicReason;
  final bool expectation;

  RecordLoadingPage({
    required this.counselId,
    required this.painRate,
    this.imageFile,
    required this.selectedSymptoms,
    required this.title,
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

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserInfo();
    await _sendDiaryData();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('id') ?? "Unknown ID";
    });
  }

  Future<void> _sendDiaryData() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
    if (baseUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 URL이 설정되지 않았습니다.";
      });
      return;
    }

    try {
      // 1단계: JSON 데이터 전송
      Map<String, dynamic> requestData = {
        "userId": _userId,
        "counselId": widget.counselId,
        "category": widget.selectedSymptoms,
        "score": widget.painRate,
        "expected": widget.expectation,
        "title": widget.title,
        "content": widget.panicReason,
      };

      final response = await http.post(
        Uri.parse("$baseUrl/diary"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      print("📢 1단계 응답 코드: ${response.statusCode}");
      print("📢 응답 바디: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final diaryId = response.body.trim();

        if (widget.imageFile != null) {
          await _uploadDiaryImage(baseUrl, diaryId);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RecordPage5()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "서버 응답 오류: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 요청 실패: $e";
      });
    }
  }

  Future<void> _uploadDiaryImage(String baseUrl, String diaryId) async {
    try {
      final uri = Uri.parse("$baseUrl/diary/image");
      final request = http.MultipartRequest("POST", uri);

      request.fields['id'] = diaryId;
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          widget.imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      print("📢 이미지 업로드 상태: ${response.statusCode}");
      print("📢 이미지 응답: $resBody");
    } catch (e) {
      print("❌ 이미지 업로드 실패: $e");
    }
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
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(_errorMessage ?? "알 수 없는 오류가 발생했습니다."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("돌아가기"),
                  ),
                ],
              ),
      ),
    );
  }
}

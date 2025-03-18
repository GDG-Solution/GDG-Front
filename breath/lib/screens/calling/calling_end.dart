import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../record/record_main.dart'; // 성공 시 이동할 페이지

class CallingEnd extends StatefulWidget {
  final String counselId;

  CallingEnd({required this.counselId});

  @override
  _CallingEndState createState() => _CallingEndState();
}

class _CallingEndState extends State<CallingEnd> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _sendUserIdToServer(); // API 요청 실행
  }

  // /counsel API에 userId를 POST 요청하는 함수
  Future<void> _sendUserIdToServer() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

    if (baseUrl.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 URL이 설정되지 않았습니다.";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/counsel/end"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"id": widget.counselId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시 RecordMain 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RecordMain(counselId: widget.counselId)),
        );
      } else {
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
                    "상담을 종료하는 중...",
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

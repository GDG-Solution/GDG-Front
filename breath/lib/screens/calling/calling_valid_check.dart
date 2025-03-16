import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calling_main.dart'; // 성공 시 이동할 페이지

class CallingValidCheck extends StatefulWidget {
  @override
  _CallingValidCheckState createState() => _CallingValidCheckState();
}

class _CallingValidCheckState extends State<CallingValidCheck> {
  bool _isLoading = true;
  String? _errorMessage;
  late String counselId; // 상담 고유 키
  late String agentResponse; // 에이전트 음성 응답

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
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserInfo(); // userId를 먼저 가져온 후 API 요청 실행
    _sendUserIdToServer();
  }

  // /counsel API에 userId를 POST 요청하는 함수
  Future<void> _sendUserIdToServer() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

    if (baseUrl.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "서버 URL이 설정되지 않았습니다.";
      });
      return;
    }

    try {
      print("userId === $_userId");
      final response = await http.post(
        Uri.parse("$baseUrl/counsel"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"userId": _userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String decodedResponse = utf8.decode(response.bodyBytes);
        final responseData = json.decode(decodedResponse);

        // ✅ 변경된 응답 형식에 맞게 데이터 저장
        counselId = responseData["id"];
        agentResponse = responseData["content"];

        print("✅ 서버 응답: counselId = $counselId");
        print("✅ 서버 응답: agentResponse (Base64) = $agentResponse");

        // ✅ CallingMain으로 이동하면서 counselId와 agentResponse 전달
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CallingMain(
              counselId: counselId,
              agentResponse: agentResponse,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = "서버 응답 오류: ${response.statusCode}";
        });
      }
    } catch (e) {
      if (!mounted) return;
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
                    "상담을 시작하는 중...",
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

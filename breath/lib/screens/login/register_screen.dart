import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  bool _idValid = true;
  bool _nameValid = true;

  // 서버에 회원가입 요청을 보내는 함수
  Future<void> _register() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? ""; // 환경 변수에서 URL 가져오기

    final String userId = _idController.text.trim();
    final String userName = _nameController.text.trim();

    // ID와 닉네임 유효성 검사
    setState(() {
      _idValid = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userId);
      _nameValid = userName.isNotEmpty;
    });

    if (!_idValid || !_nameValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": userId,
          "name": userName,
        }),
      );

      print("🔹 응답 상태 코드: ${response.statusCode}");
      print("🔹 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        final data = response.body; // 서버의 응답이 텍스트라면 그대로 사용

        if (data == "회원가입 되었습니다.") {
          // 회원가입 성공 시 처리
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('id', userId);
          await prefs.setString('name', userName);

          // 회원가입 후 홈 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // 실패 시 알림
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("회원가입 실패: $data"), // 서버에서 받은 메시지를 사용
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("회원가입 오류: ${response.body}"),
        ));
      }
    } catch (e) {
      print("❌ 서버 요청 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("서버 오류가 발생했습니다."),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF375E43), Color(0xFF3A413B)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "간편하게 회원가입하세요!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 40),

              // ✅ 아이디 입력 필드
              Text(
                "아이디",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: "아이디를 적어주세요",
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _idValid ? null : "영문과 숫자 조합이 필요해요",
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),

              // ✅ 닉네임 입력 필드
              Text(
                "닉네임",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "닉네임을 적어주세요",
                  hintStyle: TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _nameValid ? null : "닉네임은 빈 칸이 될 수 없어요",
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),

              // ✅ 회원가입 버튼
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE1F8CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "회원가입",
                          style: TextStyle(
                            color: Color(0xff275220),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

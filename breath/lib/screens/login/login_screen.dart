import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:breath/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _idValid = true;
  // bool _passwordValid = true;

  Future<void> _login(BuildContext context) async {
    final String userId = _idController.text.trim();

    // ✅ ID와 비밀번호 유효성 검사
    setState(() {
      _idValid = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userId);
      // _passwordValid = _passwordController.text.length >= 12 &&
      //     RegExp(r'[0-9]').hasMatch(_passwordController.text);
    });

    if (!_idValid) return;
    // if (!_idValid || !_passwordValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("http://121.145.241.173:8080/user?id=$userId"),
      );

      print("🔹 응답 상태 코드: ${response.statusCode}");
      print("🔹 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String userId = data["id"] ?? "Unknown";
        String userName = data["name"] ?? "No Name";
        String userDate =
            data["date"] != null ? data["date"].toString() : "N/A";

        print("✅ 로그인 성공: {id: $userId, name: $userName, date: $userDate}");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('id', userId);
        await prefs.setString('name', userName);
        await prefs.setString('date', userDate);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print("❌ 로그인 실패: ${response.body}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("❌ 로그인 실패")));
      }
    } catch (e) {
      print("❌ 로그인 요청 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ 서버 오류가 발생했습니다.")),
      );
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
                "반가워요!\n포코에 오신 걸 환영해요",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 40),

              // ✅ ID 입력 필드
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

              // ✅ 비밀번호 입력 필드
              // Text(
              //   "비밀번호",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // TextField(
              //   controller: _passwordController,
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     hintText: "************",
              //     hintStyle: TextStyle(color: Colors.white60),
              //     filled: true,
              //     fillColor: Colors.white.withOpacity(0.1),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: BorderSide.none,
              //     ),
              //     errorText: _passwordValid ? null : "영문 12자리 이상과 숫자 4자리가 필요해요",
              //   ),
              //   style: TextStyle(color: Colors.white),
              // ),

              SizedBox(height: 30),

              // Spacer(),

              // ✅ 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffE1F8CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "로그인",
                          style: TextStyle(
                            color: Color(0xff275220),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 12),

              // ✅ 가입하기 버튼
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: 회원가입 페이지 연결
                  },
                  child: Text(
                    "가입하기",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

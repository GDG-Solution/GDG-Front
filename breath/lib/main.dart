import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breath/screens/home_screen.dart';
import 'package:breath/screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env 파일 로드

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // 저장된 로그인 상태 확인
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BREATH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 화면
          } else {
            bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? HomeScreen() : LoginScreen(); // 로그인 상태 체크
          }
        },
      ),
    );
  }
}

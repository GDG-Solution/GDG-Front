import 'package:flutter/material.dart';
import 'package:breath/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BREATH',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard',
      ),
      initialRoute: '/', // 초기 경로 설정
      routes: {
        '/': (context) => HomeScreen(),
        // '/search': (context) => SearchScreen(),
        // '/profile': (context) => ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

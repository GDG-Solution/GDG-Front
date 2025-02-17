import 'package:flutter/material.dart';
import '../widgets/custom_bottom_bar.dart';
import 'calendar_screen.dart'; // 검색 화면 추가
import 'more_screen.dart'; // 프로필 화면 추가
import './calling/calling_main.dart'; // calling_main.dart 파일 import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 화면 리스트
  final List<Widget> _screens = [
    Center(child: Text('Home Screen')), // Home
    CalendarScreen(), // Search
    MoreScreen(), // Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // 선택된 화면 보여주기
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // AI 통화 기능 추가
        },
        backgroundColor: Color(0xFF6EE95C),
        child: Icon(Icons.call, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 중앙 배치
    );
  }
}

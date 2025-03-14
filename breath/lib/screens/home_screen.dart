import 'package:flutter/material.dart';
// import '../widgets/custom_bottom_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import './home/home_main_screen.dart'; // 홈 UI 화면 추가
import './calendar/calendar_screen.dart'; // 검색 화면 추가
import './calling/calling_main.dart'; // calling_main.dart 파일 import
import './calling/calling_valid_check.dart'; // calling_main.dart 파일 import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeMainScreen(),
    CalendarScreen(),
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
      floatingActionButton: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 8,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CallingValidCheck()),
            );
          },
          backgroundColor: Color(0xff6EE95C),
          elevation: 0,
          shape: CircleBorder(),
          child: Image.asset("assets/icons/bottom/call.png", width: 27),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 중앙 배치
    );
  }
}

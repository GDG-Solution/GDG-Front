import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breath/screens/login/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // 로그인 상태 삭제

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          // 프로필 버튼
        },
        child: Image.asset(
          "assets/icons/home/profile_icon.png",
          width: 40,
          height: 40,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () => _logout(context), // 로그아웃 버튼
        ),
        GestureDetector(
          onTap: () {
            // 공황 기록 버튼
          },
          child: Image.asset(
            "assets/icons/home/more_icon.png",
            width: 32,
            height: 32,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            // 알림 버튼
          },
          child: Image.asset(
            "assets/icons/home/alert_icon.png",
            width: 32,
            height: 32,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}

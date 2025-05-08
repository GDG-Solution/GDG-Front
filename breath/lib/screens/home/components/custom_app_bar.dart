import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breath/screens/login/login_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName; // 사용자 이름을 받는 변수

  CustomAppBar({Key? key, required this.userName}) : super(key: key);

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
        child: Row(
          children: [
            Image.asset(
              "assets/icons/home/profile_icon.png",
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              userName, // 여기서 사용자 이름을 표시
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white, // 텍스트 색상
                  fontSize: 16, // 텍스트 크기
                ),
              ),
            ],
          ),
          onPressed: () => _logout(context), // 로그아웃 버튼
        ),
        SizedBox(width: 5),
      ],
    );
  }
}

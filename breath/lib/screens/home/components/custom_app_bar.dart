import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: IconButton(
        icon: Icon(Icons.account_circle, color: Colors.white),
        onPressed: () {
          // 프로필 화면 이동
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // 공황 기록 추가
          },
        ),
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            // 알림 기능
          },
        ),
      ],
    );
  }
}

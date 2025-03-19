import 'package:flutter/material.dart';

class CustomDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomDetailAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context); // 이전 화면으로 돌아가기
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent, // 상단바 배경색
      elevation: 0,
      actions: [
        // 오른쪽에 다른 아이콘들을 추가하고 싶다면 여기에 추가
        // IconButton(icon: Icon(Icons.share), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // AppBar 높이
}

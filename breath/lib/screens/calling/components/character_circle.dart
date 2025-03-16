import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CharacterCircle extends StatefulWidget {
  @override
  _CharacterCircleState createState() => _CharacterCircleState();
}

class _CharacterCircleState extends State<CharacterCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // ✅ 4초 뒤부터 반복 실행
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 186,
      height: 186,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff35643E), // 배경색 조정
      ),
      child: ClipOval(
        child: Lottie.asset(
          'assets/lottie/lottie_call.json',
          controller: _controller,
          fit: BoxFit.cover, // 애니메이션을 꽉 채우기
          onLoaded: (composition) {
            _controller.duration = composition.duration; // 전체 애니메이션 길이 설정
          },
        ),
      ),
    );
  }
}

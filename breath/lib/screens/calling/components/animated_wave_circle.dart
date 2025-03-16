import 'package:flutter/material.dart';

class AnimatedWaveCircle extends StatefulWidget {
  @override
  _AnimatedWaveCircleState createState() => _AnimatedWaveCircleState();
}

class _AnimatedWaveCircleState extends State<AnimatedWaveCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // 2초 동안 애니메이션 실행
    )..repeat(); // 반복 실행
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double progress = (_controller.value + index * 0.3) % 1.0;
            return Opacity(
              opacity: 1 - progress, // 점점 투명해짐
              child: Container(
                width: 180 + progress * 100, // 점점 커짐
                height: 180 + progress * 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

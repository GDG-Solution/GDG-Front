import 'package:flutter/material.dart';

class AnimatedWaveCircle extends StatelessWidget {
  final AnimationController controller;
  const AnimatedWaveCircle({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 225 * controller.value,
          height: 225 * controller.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
        );
      },
    );
  }
}

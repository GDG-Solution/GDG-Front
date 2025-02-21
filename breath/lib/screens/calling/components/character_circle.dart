import 'package:flutter/material.dart';

class CharacterCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 186,
      height: 186,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red[300],
      ),
      child: Center(
        child: Text('캐릭터 영상', textAlign: TextAlign.center),
      ),
    );
  }
}

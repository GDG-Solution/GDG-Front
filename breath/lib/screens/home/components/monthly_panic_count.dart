import 'package:flutter/material.dart';

class MonthlyPanicCount extends StatelessWidget {
  final int count;

  const MonthlyPanicCount({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          text: "이번 달에\n이겨낸 나의 공황은 ",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          children: [
            TextSpan(
              text: "$count 개",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff6EE95C)),
            ),
          ],
        ),
      ),
    );
  }
}

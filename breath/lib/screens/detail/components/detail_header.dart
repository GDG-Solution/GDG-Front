import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final String date;

  const DetailHeader({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              date,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }
}

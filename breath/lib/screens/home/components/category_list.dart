import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> tags;

  const CategoryList({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 태그 간격
      runSpacing: 4.0, // 줄 바꿈 간격
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFFD7E8D4), // 배경색 (연한 초록색)
            borderRadius: BorderRadius.circular(12), // 모서리 둥글게
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF35643E), // 글자색 (진한 초록색)
            ),
          ),
        );
      }).toList(),
    );
  }
}

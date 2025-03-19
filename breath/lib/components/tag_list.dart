import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final List<String> tags; // 태그 목록을 받아서 사용

  const TagList({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // Row 대신 Wrap을 사용하여 태그가 넘치면 줄바꿈 가능
      spacing: 8, // 태그 사이 여백
      children: tags.map((tag) => _buildTag(tag)).toList(), // 태그 리스트 렌더링
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100], // 배경색
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
      ),
    );
  }
}

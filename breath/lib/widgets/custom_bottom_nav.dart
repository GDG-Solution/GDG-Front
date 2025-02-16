import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // FAB 공간 확보
      notchMargin: 8.0,
      child: Container(
        height: 60, // 바텀 바 높이
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.article, "공황 기록", 0),
            SizedBox(width: 40), // FAB 공간 확보
            _buildNavItem(Icons.bar_chart, "공황 분석", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: index == currentIndex
                  ? Color(0xff111111)
                  : Color(0xFFA1A1A1)),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  index == currentIndex ? Color(0xff111111) : Color(0xFFA1A1A1),
            ),
          ),
        ],
      ),
    );
  }
}

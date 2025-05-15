import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: 130,
        child: SafeArea(
          child: BottomAppBar(
            // color: Colors.white,
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                      "assets/icons/bottom/first_active.png", "공황기록", 0),
                  SizedBox(width: 50),
                  _buildNavItem("assets/icons/bottom/second.png", "전화분석", 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 24,
            color:
                index == currentIndex ? Color(0xff111111) : Color(0xFFA1A1A1),
          ),
          SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  index == currentIndex ? Color(0xff111111) : Color(0xFFA1A1A1),
            ),
          ),
        ],
      ),
    );
  }
}

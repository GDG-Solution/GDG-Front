import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategoryFilter({required this.onCategorySelected});

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  String selectedCategory = "전체";

  final List<String> categories = ["전체", "호흡곤란", "숨 가쁨", "질식"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((category) {
        bool isSelected = selectedCategory == category;
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected
                ? Color(0xffffffff)
                : Color(0xFFFFFFFF).withOpacity(0.3), // 70% 투명
            foregroundColor: isSelected ? Color(0xff111111) : Color(0xffffffff),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedCategory = category;
            });
            widget.onCategorySelected(category);
          },
          child: Text(category),
        );
      }).toList(),
    );
  }
}

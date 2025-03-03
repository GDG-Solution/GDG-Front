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
            backgroundColor: isSelected ? Colors.green[300] : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

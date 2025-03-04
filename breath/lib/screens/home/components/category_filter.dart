import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  final Function(String) onCategorySelected;

  CategoryFilter({required this.onCategorySelected});

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  String selectedCategory = "전체";
  final List<String> categories = [
    "전체",
    "호흡곤란",
    "숨 가쁨",
    "질식",
    "두근거림",
    "어지러움",
    "땀남",
    "떨림",
    "메스꺼움",
    "가슴통증"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories[index];
            bool isSelected = selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // 버튼 간격 조정
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isSelected
                      ? Color(0xffffffff)
                      : Color(0xFFFFFFFF).withOpacity(0.3), // 70% 투명
                  foregroundColor:
                      isSelected ? Color(0xff111111) : Color(0xffffffff),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
                child: Text(category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            );
          },
        ));
  }
}

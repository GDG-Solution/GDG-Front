import 'package:flutter/material.dart';
import '../../../components/pain_level_dots.dart';

class PainLevelSelector extends StatefulWidget {
  final Function(int) onSelected;

  const PainLevelSelector({Key? key, required this.onSelected})
      : super(key: key);

  @override
  _PainLevelSelectorState createState() => _PainLevelSelectorState();
}

class _PainLevelSelectorState extends State<PainLevelSelector> {
  int _selectedPainRate = -1; // 초기 선택값 (-1: 아무것도 선택되지 않음)

  final List<Map<String, dynamic>> painLevels = [
    {"label": "매우 강함", "level": 5},
    {"label": "강함", "level": 4},
    {"label": "중간", "level": 3},
    {"label": "약함", "level": 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: painLevels.length,
        itemBuilder: (context, index) {
          final item = painLevels[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPainRate = index;
              });
              widget.onSelected(item["level"]); // 선택한 값 전달
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: _selectedPainRate == index
                    ? Colors.white
                    : Color(0xFFF9FEF3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Row(
                children: [
                  // Container(width: 48, height: 48, color: Colors.grey[400]),
                  // SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PainLevelDots(
                        painRate: item["level"],
                      ),
                      SizedBox(height: 8),
                      Text(
                        item["label"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff275220),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    _selectedPainRate == index
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color:
                        _selectedPainRate == index ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

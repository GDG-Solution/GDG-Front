import 'package:flutter/material.dart';

class RecordMain extends StatefulWidget {
  @override
  _RecordMainState createState() => _RecordMainState();
}

class _RecordMainState extends State<RecordMain> {
  int _selectedIndex = -1; // ✅ 선택된 인덱스 (-1: 아무것도 선택되지 않음)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3FCE7), // ✅ 배경색 적용
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),

            // ✅ 상단 메시지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/record/leaf_left.png", width: 37),
                SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      "오늘도 이겨냈어요!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff275220),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "분석을 위해 고통 수치를 선택해주세요",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff728C78),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Image.asset("assets/images/record/leaf_right.png", width: 37),
              ],
            ),

            SizedBox(height: 67),

            // ✅ 캐릭터 박스
            Container(
              width: 137,
              height: 92,
              color: Colors.grey[400],
              alignment: Alignment.center,
              child: Text("캐릭터"),
            ),

            // ✅ 선택 리스트
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildOption(0, "매우 강함", Color(0xFFFF6224), 5),
                  _buildOption(1, "강함", Color(0xFFFF800A), 4),
                  _buildOption(2, "중간", Color(0xFFFFBD24), 3),
                  _buildOption(3, "약함", Color(0xFFF6DD96), 2),
                ],
              ),
            ),

            // ✅ 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton("안하기", 88, Color(0xFFDBE3D0)!,
                      Color(0xff728C78), Color(0xffCBE0B8), () {
                    Navigator.of(context)
                        .popUntil((route) => route.isFirst); // ✅ 홈 화면 이동
                  }),
                  _actionButton("기록하기", 272, Color(0xFFE1F8CC)!,
                      Color(0xFF275220), Color(0xffCBE0B8), () {
                    // ✅ 기록 페이지로 이동 (아직 없음)
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 옵션 리스트 아이템
  Widget _buildOption(int index, String label, Color dotColor, int dotCount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.white : Color(0xFFF9FEF3),
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: _selectedIndex == index ? Colors.green : Colors.transparent,
            //   width: 2,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // 투명도 8% 적용
                offset: Offset(0, 2), // X: 0, Y: 2
                blurRadius: 4, // Blur: 4
                spreadRadius: 0, // Spread: 0
              )
            ]),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              color: Colors.grey[400],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      5 - dotCount,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.circle, color: Colors.grey, size: 10),
                      ),
                    ),
                    ...List.generate(
                      dotCount,
                      (i) => Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.circle, color: dotColor, size: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff275220)),
                ),
              ],
            ),
            Spacer(),
            Icon(
              _selectedIndex == index
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedIndex == index ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 하단 버튼
  Widget _actionButton(String text, double width, Color bgColor,
      Color textColor, Color borderColor, VoidCallback onPressed) {
    return SizedBox(
      width: width,
      height: 72,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: borderColor, width: 1),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

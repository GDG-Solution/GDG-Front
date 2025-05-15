import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './panic_level_card.dart';

class CallAnalysisScreen extends StatefulWidget {
  @override
  _CallAnalysisScreenState createState() => _CallAnalysisScreenState();
}

class _CallAnalysisScreenState extends State<CallAnalysisScreen> {
  int selectedYear = DateTime.now().year;
  int selectedMonthInt = DateTime.now().month;

  String _userId = "";
  int diaryNum = 0;
  List<dynamic> symptomStats = [];
  Map<String, dynamic> expectationStat = {};
  List<dynamic> scoreStats = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      _fetchAnalysisData(); // 최초 분석 데이터 호출
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    setState(() {
      _userId = id ?? "";
    });
  }

  //String get selectedMonthText => "$selectedYear년 ${selectedMonthInt}월";
  String get selectedMonthText => "${selectedMonthInt}월";

  String _getFormattedYearMonth() {
    return "$selectedYear-${selectedMonthInt.toString().padLeft(2, '0')}";
  }

  void _changeMonth(int direction) {
    setState(() {
      selectedMonthInt += direction;

      if (selectedMonthInt < 1) {
        selectedMonthInt = 12;
        selectedYear -= 1;
      } else if (selectedMonthInt > 12) {
        selectedMonthInt = 1;
        selectedYear += 1;
      }
    });

    _fetchAnalysisData();
  }

  Future<void> _fetchAnalysisData() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
    final String yearMonth = _getFormattedYearMonth();

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/analysis?id=$_userId&yearMonth=$yearMonth"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          diaryNum = jsonData['diaryNum'] ?? 0;
          symptomStats = jsonData['symptomStats'] ?? [];
          expectationStat = jsonData['expectationStat'] ?? {};
          scoreStats = jsonData['scoreStats'] ?? [];
        });
      } else {
        print("❌ 분석 API 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 분석 API 호출 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "전화 분석",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF375E43), // 상단바 배경색
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF375E43), Color(0xFF3A413B)],
              ),
            ),
          ),
          SafeArea(
            bottom: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  _buildMonthSelector(), // 월 선택
                  SizedBox(height: 10),
                  // 기록 트로피 수
                  Center(
                    child: _buildTrophyCount(),
                  ),

                  SizedBox(height: 20),

                  // 가장 많이 나타낸 증상
                  _buildMostCommonSymptoms(),

                  SizedBox(height: 20),

                  // 예상했던 공황의 수
                  _buildExpectedPanicCount(),

                  SizedBox(height: 20),

                  // 나의 공포수치 변화
                  _buildPanicLevelChanges(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// 월 선택
  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0), // 양옆 여백
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildArrowButton(Icons.chevron_left, () => _changeMonth(-1)),
          Text(
            selectedMonthText, // "2025년 5월"
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          _buildArrowButton(Icons.chevron_right, () => _changeMonth(1)),
        ],
      ),
    );
  }

// 달 이동 버튼 UI
  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // 반투명 회색 배경
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // 기록 트로피 수
  Widget _buildTrophyCount() {
    return Container(
      width: 369,
      height: 103,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x1A000000),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "기록 트로피 수",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/record/trophy.png", width: 39),
              SizedBox(width: 5),
              Text(
                "$diaryNum", // 트로피 수 예시
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // 가장 많이 나타낸 증상
  Widget _buildMostCommonSymptoms() {
    final top2 = symptomStats.take(2).toList();

    return Container(
      width: 369,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x1A000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "가장 많았던 증상",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          ...top2.asMap().entries.map((entry) {
            final index = entry.key;
            final symptom = entry.value;
            final name = symptom['name'] ?? 'N/A';
            final count = symptom['count'] ?? 0;
            final ratio = (count / (top2[0]['count'] ?? 1)).clamp(0.0, 1.0);

            // 색상 구분
            final isPrimary = index == 0;
            final barColor =
                isPrimary ? Color(0xFFFFBD24) : Colors.grey.withOpacity(0.6);
            final textColor =
                isPrimary ? Colors.black : Colors.black.withOpacity(0.5);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: ratio),
                duration: Duration(milliseconds: 800),
                builder: (context, animatedValue, child) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: animatedValue,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          minHeight: 36,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

// 예상했던 공황의 수
  Widget _buildExpectedPanicCount() {
    final int o = expectationStat['o'] ?? 0;
    final int x = expectationStat['x'] ?? 0;

    final bool isOBigger = o >= x;
    final Color oColor = isOBigger ? Color(0xFFFFBD24) : Colors.grey;
    final Color xColor = !isOBigger ? Color(0xFFFFBD24) : Colors.grey;

    final double bigSize = 100;
    final double smallSize = 80;

    return Container(
      width: 369,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x1A000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "예상했던 공황의 수",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircle("O", oColor, "${o}번",
                  size: isOBigger ? 100 : 80, isHighlighted: isOBigger),
              SizedBox(width: 20),
              _buildCircle("X", xColor, "${x}번",
                  size: isOBigger ? 80 : 100, isHighlighted: !isOBigger),
            ],
          ),
        ],
      ),
    );
  }

// 동그라미와 그 안의 텍스트를 빌드하는 함수
  Widget _buildCircle(
    String text,
    Color color,
    String number, {
    double size = 100,
    bool isHighlighted = true, // 큰 값일 때 true, 작은 값일 때 false
  }) {
    final Color circleColor = isHighlighted ? color : color.withOpacity(0.6);
    final double mainFontSize = isHighlighted ? 32 : 24;
    final double subFontSize = isHighlighted ? 16 : 14;
    final Color textColor =
        isHighlighted ? Colors.black : Colors.black.withOpacity(0.6);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color, // 동그라미 색
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text, // O 또는 X
              style: TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              number,
              style: TextStyle(
                fontSize: subFontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 나의 공포수치 변화
  Widget _buildPanicLevelChanges() {
    final List<dynamic> recentScores = List.from(scoreStats)
      ..sort((a, b) =>
          DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    final top3 = recentScores.take(3).toList();

    return Container(
      width: 369,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x1A000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "나의 공포수치 변화",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          ...top3.map((entry) {
            final date =
                DateTime.tryParse(entry['date'] ?? "") ?? DateTime.now();
            final score = entry['score'] ?? 0;
            final day = "${date.day}일";
            final time = DateFormat('a hh:mm', 'ko').format(date);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PanicLevelCard(day: day, time: time, level: score),
            );
          }).toList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import './panic_level_card.dart';

class CallAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "전화 분석",
          style: TextStyle(
            fontSize: 20,
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), // 전체 여백 추가
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
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
        ],
      ),
    );
  }

  // 기록 트로피 수
  Widget _buildTrophyCount() {
    return Container(
      width: 369,
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFF)),
          ),
          SizedBox(height: 10),
          Image.asset("assets/images/record/trophy.png", width: 39),
          Text(
            "1", // 트로피 수 예시
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF)),
          ),
        ],
      ),
    );
  }

  // 가장 많이 나타낸 증상
  Widget _buildMostCommonSymptoms() {
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.8), // 0 ~ 1 사이
                  duration: Duration(seconds: 2), // 애니메이션 시간
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value, // 진행 상태 (0~1 사이)
                      backgroundColor: Colors.transparent, // 배경색
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange), // 진행 색
                      minHeight: 36, // 진행바 높이
                    );
                  },
                ),
              ),
              // 진행바 위에 텍스트
              Positioned.fill(
                child: Center(
                  child: Text(
                    "기술 통증",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// 예상했던 공황의 수
  Widget _buildExpectedPanicCount() {
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
            children: [
              Text(
                "0", // 예시로 0으로 설정, 실제 데이터에 맞게 수정
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Text(
                "32번", // 예시로 32번, 실제 데이터에 맞게 수정
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "20회", // 예시로 20회, 실제 데이터에 맞게 수정
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

// 나의 공포수치 변화
  Widget _buildPanicLevelChanges() {
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
          // 공포수치에 따라 카드 변경
          PanicLevelCard(month: "6월", time: "오후 13:00", level: 5),
          SizedBox(height: 10),
          PanicLevelCard(month: "5월", time: "오후 13:00", level: 4),
          SizedBox(height: 10),
          PanicLevelCard(month: "1월", time: "오후 13:00", level: 3),
        ],
      ),
    );
  }
}

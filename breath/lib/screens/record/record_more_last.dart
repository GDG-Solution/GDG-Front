import 'package:flutter/material.dart';
import '../home_screen.dart';
import './components/custom_button.dart';

class RecordPage5 extends StatefulWidget {
  @override
  _RecordPage5State createState() => _RecordPage5State();
}

class _RecordPage5State extends State<RecordPage5> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // ✅ 기본 뒤로 가기 방지
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF3FCE7),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 100),

              // ✅ 상단 메시지
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/record/leaf_left.png", width: 37),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        "최고예요!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff275220),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "기록한 상으로 트로피를 드려요",
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
              SizedBox(height: 80),

              // ✅ 캐릭터 박스
              Container(
                width: 236,
                height: 236,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/record/record_last.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Spacer(),

              // ✅ 하단 버튼
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "오늘도 성공",
                      width: 365,
                      bgColor: Color(0xFFE1F8CC),
                      textColor: Color(0xff275220),
                      borderColor: Color(0xff0000001A),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst); // 첫 페이지로 돌아가기
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen()), // 새로 고침된 첫 페이지로 이동
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

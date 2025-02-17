import 'package:flutter/material.dart';

class CallingMain extends StatefulWidget {
  @override
  _CallingMainState createState() => _CallingMainState();
}

class _CallingMainState extends State<CallingMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // ✅ 상단 앱바
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF35643E), // 진한 녹색 (중심)
              Color(0xFF728C78), // 밝은 연두색 (외곽)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ 상, 중, 하 균등 분배
          children: [
            // ✅ 1. 상단 영역 (타이머 등)
            SizedBox(height: 10),

            // ✅ 2. 중앙 영역 (캐릭터 + 애니메이션)
            Column(
              children: [
                Container(
                  // 캐릭터 영상
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedWaveCircle(controller: _controller), // 애니메이션 효과
                      CharacterCircle(), // 중앙 캐릭터
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.35,
                        child: PageIndicator(), // 페이지 인디케이터
                      )
                    ],
                  ),
                ),

                // SizedBox(height: 10),
                // PageIndicator(), // 페이지 인디케이터
                SizedBox(height: 0),
                Container(
                  height: 72, // ✅ 높이를 줄여서 버튼 스타일처럼 만들기
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 35), // ✅ 좌우 여백 추가
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // ✅ 반투명한 배경
                    borderRadius: BorderRadius.circular(20), // ✅ 둥근 모서리
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5), // ✅ 반투명한 테두리
                      width: 1.5, // ✅ 테두리 두께
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "우연아 앞에 보이는 것들 아무거나 얘기해줘",
                    style: TextStyle(
                      color: Colors.white, // ✅ 흰색 텍스트
                      fontSize: 16, // ✅ 적절한 폰트 크기
                      fontWeight: FontWeight.w600, // ✅ 중간 굵기 적용
                    ),
                    textAlign: TextAlign.center, // ✅ 텍스트 중앙 정렬
                  ),
                )
              ],
            ),

            // ✅ 3. 하단 영역 (마이크 버튼)
            Padding(
              padding: EdgeInsets.only(bottom: 100), // ✅ 버튼 하단 여백 추가
              child: MicButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 상단 앱바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // ✅ 배경 투명
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {},
      ),
      title: Text('05:00', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.call_end, color: Colors.redAccent),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ✅ 원형 애니메이션 효과
class AnimatedWaveCircle extends StatelessWidget {
  final AnimationController controller;
  const AnimatedWaveCircle({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 225 * controller.value,
          height: 225 * controller.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
        );
      },
    );
  }
}

// ✅ 중앙 캐릭터 원형 박스
class CharacterCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 186,
      height: 186,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red[300],
      ),
      child: Center(
        child: Text('캐릭터 영상', textAlign: TextAlign.center),
      ),
    );
  }
}

// ✅ 페이지 인디케이터
class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 1 ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}

// ✅ 하단 마이크 버튼
class MicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ Column이 내용만큼만 차지하도록 설정
      children: [
        Text('눌러서 대답하기', style: TextStyle(color: Colors.white)),
        SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            print("마이크 버튼 클릭됨");
          },
          child: Container(
            width: 122,
            height: 122,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              color: Colors.greenAccent,
            ),
            child: Icon(Icons.mic, color: Colors.white, size: 45),
          ),
        ),
      ],
    );
  }
}

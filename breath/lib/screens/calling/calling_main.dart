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
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center, // ✅ 원형 그라데이션 중심을 상단으로 설정
            radius: 1.2, // ✅ 그라데이션 반경 조정
            colors: [
              Color(0xFF35643E), // 진한 녹색 (중심)
              Color(0xFFE1F8CC), // 밝은 연두색 (외곽)
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedWaveCircle(controller: _controller), // 애니메이션 효과
            CharacterCircle(), // 중앙 캐릭터
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.35,
              child: PageIndicator(), // 페이지 인디케이터
            ),
            Align(
              alignment: Alignment.bottomCenter, // ✅ 하단 중앙 정렬
              child: Padding(
                padding: EdgeInsets.only(bottom: 50), // ✅ 하단 여백 조정
                child: MicButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상단 앱바
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
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
          width: 150 * controller.value,
          height: 150 * controller.value,
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
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
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

// ✅ 하단 마이크 버튼 (위치 수정 완료)
class MicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // ✅ 하단 중앙 정렬
      child: Padding(
        padding: EdgeInsets.only(bottom: 50), // ✅ 하단 여백 조정
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Column이 내용만큼만 차지하도록 설정
          children: [
            Text('눌러서 대답하기', style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                print("마이크 버튼 클릭됨");
              },
              child: Container(
                width: 80,
                height: 80,
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
                child: Icon(Icons.mic, color: Colors.white, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

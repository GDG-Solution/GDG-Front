import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import './components/animated_wave_circle.dart';
import './components/character_circle.dart';
import './components/end_call_dialog.dart';

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
      appBar: _buildAppBar(context), // ✅ 상단 앱바
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 상, 중, 하 균등 분배
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
                      AnimatedWaveCircle(controller: _controller),
                      CharacterCircle(),
                    ],
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  height: 72, // 높이를 줄여서 버튼 스타일처럼 만들기
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 35), // 좌우 여백 추가
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20), // 둥근 모서리
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5), // 반투명한 테두리
                      width: 1.5, // 테두리 두께
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "우연아 앞에 보이는 것들 아무거나 얘기해줘",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),

            // ✅ 3. 하단 영역 (마이크 버튼)
            Padding(
              padding: EdgeInsets.only(bottom: 100), // 버튼 하단 여백 추가
              child: MicButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 상단 앱바
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF728C78),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "05:00",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.call_end, color: Colors.redAccent),
          onPressed: () => showEndCallDialog(context),
        ),
      ],
    );
  }
}

// ✅ 마이크 버튼
class MicButton extends StatefulWidget {
  @override
  _MicButtonState createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Column이 내용만큼만 차지하도록 설정
      children: [
        Text(
          _isListening ? "듣고 있어요..." : "눌러서 대답하기",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        GestureDetector(
          onTap: _toggleListening,
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
              color: _isListening ? Colors.redAccent : Colors.greenAccent,
            ),
            child: Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
              size: 45,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 마이크 ON/OFF 함수
  void _toggleListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
      print("🗣 인식된 텍스트: $_recognizedText"); // 변환된 텍스트 출력
    } else {
      bool available = await _speech.initialize(
        onStatus: (status) => print("🎙 상태: $status"),
        onError: (error) => print("❌ 오류: $error"),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
          },
        );
      }
    }
  }
}

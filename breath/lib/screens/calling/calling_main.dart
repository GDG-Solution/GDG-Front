import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import './components/animated_wave_circle.dart';
import './components/character_circle.dart';
import './components/end_call_dialog.dart';
import './components/custom_message_box.dart';

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
                CustomMessageBox(message: "우연아 앞에 보이는 것들 아무거나 얘기해줘"),
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
      title: Container(
        child: Row(
          children: [
            Image.asset("assets/images/calling/timer_icon.png", width: 18),
            Container(width: 10),
            Text(
              "05:00",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {
              showEndCallDialog(context);
            },
            child: Image.asset("assets/images/calling/stop_calling.png",
                width: 36),
          ),
        )
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
  String _recognizedText = "듣고 있어요...";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Column이 내용만큼만 차지하도록 설정
      children: [
        Text(
          _isListening ? _recognizedText : "눌러서 대답하기",
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
      print("🗣 최종 인식된 텍스트: $_recognizedText"); // 변환된 텍스트 출력
    } else {
      bool available = false;

      try {
        available = await _speech.initialize(
          onStatus: (status) => print("🎙 상태: $status"),
          onError: (error) => print("❌ 오류: $error"),
        );
      } catch (e) {
        print("❌ 음성 인식 초기화 실패: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ 음성 인식을 사용할 수 없습니다."),
          ),
        );
        return;
      }

      if (!available) {
        print("⚠️ 음성 인식 서비스를 사용할 수 없습니다. (에뮬레이터에서는 정상 작동하지 않을 수 있음)");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ 음성 인식을 사용할 수 없습니다."),
          ),
        );
        return;
      }

      setState(() {
        _isListening = true;
        _recognizedText = "듣고 있어요..."; // 기존 텍스트 초기화
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          print("🔹 실시간 인식 중: ${result.recognizedWords}"); // 실시간으로 콘솔에 출력
        },
      );
    }
  }
}

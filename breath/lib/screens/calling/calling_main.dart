import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart'; // TTS 패키지 임포트

import './components/animated_wave_circle.dart';
import './components/character_circle.dart';
import './components/end_call_dialog.dart';
import './components/custom_message_box.dart';

class CallingMain extends StatefulWidget {
  final String counselId;
  final String agentResponse;

  CallingMain({required this.counselId, required this.agentResponse});

  @override
  _CallingMainState createState() => _CallingMainState();
}

class _CallingMainState extends State<CallingMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _agentResponse = ""; // 서버 응답 저장
  FlutterTts _flutterTts = FlutterTts(); // TTS 객체 생성

  @override
  void initState() {
    super.initState();
    _agentResponse = widget.agentResponse; // 초기 메시지 설정

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _flutterTts.setLanguage("ko-KR"); // 한국어 설정
    _flutterTts.setSpeechRate(0.8); // 속도
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // 상단 앱바
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 상, 중, 하 균등 분배
              children: [
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedWaveCircle(),
                          CharacterCircle(),
                        ],
                      ),
                    ),
                    SizedBox(height: 0),
                    CustomMessageBox(message: _agentResponse), // 변경된 메시지 반영
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: MicButton(
                    counselId: widget.counselId, // 상담 ID 전달
                    onResponseReceived: (response) {
                      setState(() {
                        _agentResponse = response; // 서버 응답을 반영
                      });
                      _speakResponse(response); // 음성으로 응답 읽기
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/calling/timer_icon.png", width: 18),
          SizedBox(width: 10),
          Text(
            "전화 연결됨!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {
              showEndCallDialog(context, widget.counselId);
            },
            child: Image.asset("assets/images/calling/stop_calling.png",
                width: 36),
          ),
        )
      ],
    );
  }

  // 음성으로 응답 읽기
  void _speakResponse(String response) async {
    await _flutterTts.speak(response); // 서버에서 받은 응답을 음성으로 읽기
  }
}

// 마이크 버튼
class MicButton extends StatefulWidget {
  final String counselId;
  final Function(String) onResponseReceived;

  MicButton({required this.counselId, required this.onResponseReceived});

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
      mainAxisSize: MainAxisSize.min,
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
              color: _isListening
                  ? Color(0xffE1F8CC)
                  : Color(0xffFFFFFF).withOpacity(0.3),
            ),
            child: Icon(
              _isListening ? Icons.mic_off : Icons.mic,
              color: _isListening ? Color(0xff35643E) : Color(0xffF1FDEF),
              size: 45,
            ),
          ),
        ),
      ],
    );
  }

  // 마이크 ON/OFF 함수
  void _toggleListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
      print("🗣 최종 인식된 텍스트: $_recognizedText");

      // 음성 인식 후 서버로 요청 보내기
      await _sendSpeechToServer();
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
        print("⚠️ 음성 인식 서비스를 사용할 수 없습니다.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ 음성 인식을 사용할 수 없습니다."),
          ),
        );
        return;
      }

      setState(() {
        _isListening = true;
        _recognizedText = "듣고 있어요...";
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

  // 서버로 음성 데이터 전송
  Future<void> _sendSpeechToServer() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/counsel/agent/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "counselId": widget.counselId,
          "content": _recognizedText,
        }),
      );

      if (response.statusCode == 200) {
        String responseData = response.body; // JSON이 아니라면 그냥 문자열로 저장
        print("✅ 서버 응답: $responseData");

        // 응답을 UI에 반영
        widget.onResponseReceived(responseData);
      } else {
        print("❌ 서버 오류: ${response.body}");
      }
    } catch (e) {
      print("❌ 요청 실패: $e");
    }
  }
}

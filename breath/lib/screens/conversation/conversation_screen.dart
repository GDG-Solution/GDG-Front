import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {"sender": "bot", "text": "먼저 숨을 고르고 내 말에 따라 행동해줘", "time": "오후 7:00"},
    {"sender": "user", "text": "어어", "time": "오후 7:00"},
    {"sender": "bot", "text": "눈 앞에 보이는 거 얘기해봐", "time": "오후 7:00"},
    {"sender": "user", "text": "그건 어 스타벅스가 보여", "time": "오후 7:00"},
    {
      "sender": "bot",
      "text": "버거워보이니까, 천천히 시작해보자.\n스타벅스 먼저 쳐다볼래?",
      "time": "오후 7:00"
    },
    {"sender": "user", "text": "응 쳐다보고 있어 쓰러질 것 같아", "time": "오후 7:00"},
    {
      "sender": "bot",
      "text": "잘하고 있어! 잠시 몸을 펴고 숨쉬기 법을 계속 유지해줘",
      "time": "오후 7:00"
    },
    {"sender": "user", "text": "하 진짜 힘들다 괜찮아졌어", "time": "오후 7:00"},
    {
      "sender": "bot",
      "text": "다행이야\n이번 공황도 이겨냈어!\n전화 끊고 기록해두면 증상이 완화될거야.",
      "time": "오후 7:00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대화내용'),
        backgroundColor: Color(0xFF3A413B),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFF3A413B),
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(
            "2024년 7월 21일",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser ? Color(0xFFE1F8CC) : Color(0xFF4E5C4B),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        constraints: BoxConstraints(maxWidth: 280),
                        child: Text(
                          msg['text'],
                          style: TextStyle(
                            color: isUser ? Color(0xFF275220) : Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: isUser ? 0 : 8,
                          right: isUser ? 8 : 0,
                        ),
                        child: Text(
                          msg['time'],
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

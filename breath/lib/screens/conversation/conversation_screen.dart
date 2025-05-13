import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationScreen extends StatefulWidget {
  final String counselId;

  const ConversationScreen({Key? key, required this.counselId})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/counsel/message?counselId=${widget.counselId}"),
      );

      print("📥 응답 상태: ${response.statusCode}");
      print("📥 응답 바디: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        final List<dynamic> messageList = jsonData["messages"] ?? [];

        setState(() {
          messages = messageList.map<Map<String, dynamic>>((msg) {
            return {
              "sender": msg["role"] == "user" ? "user" : "bot",
              "text": msg["content"],
              "time": msg["date"] ?? "", // LocalDateTime → 문자열 그대로
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception("서버 오류 발생: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 메시지 불러오기 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대화내용'),
        backgroundColor: Color(0xFF3A413B),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFF3A413B),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 16),
                Text(
                  "상담 ID: ${widget.counselId}",
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
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Color(0xFFE1F8CC)
                                    : Color(0xFF4E5C4B),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              constraints: BoxConstraints(maxWidth: 280),
                              child: Text(
                                msg['text'],
                                style: TextStyle(
                                  color:
                                      isUser ? Color(0xFF275220) : Colors.white,
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
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 11),
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

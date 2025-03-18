import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import './components/category_filter.dart';
import './components/panic_list.dart';
import './components/custom_app_bar.dart';
import './components/monthly_panic_count.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeMainScreen extends StatefulWidget {
  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  String _userName = "";
  String _userId = "";

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('id') ?? "Unknown ID";
      String? savedName = prefs.getString('name');
      _userName = savedName != null
          ? utf8.decode(savedName.codeUnits)
          : "Unknwon User"; // 한글 디코딩
    });
    print("userId: ${_userId}");
    print("userName: ${_userName}");
  }

  List<Map<String, dynamic>> panicRecords = []; // 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadPanicRecords(); // JSON 데이터 불러오기
    _loadUserInfo(); // 저장된 사용자 정보 불러오기
  }

  Future<void> _loadPanicRecords() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
    final String userId = _userId; // ✅ 특정 사용자 ID (임시값)

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/diary/user?id=$userId"),
      );

      print("✅ 서버 응답 상태 코드: ${response.statusCode}");
      print("✅ 서버 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        // 확인: diaries가 없거나 빈 리스트일 경우, panicRecords에 빈 리스트 할당
        List<dynamic> allDiaries = jsonData['diaries'] ?? [];

        // 데이터가 없을 경우
        if (allDiaries.isEmpty) {
          setState(() {
            panicRecords = [];
          });
          print("❌ 기록이 없습니다.");
        } else {
          setState(() {
            panicRecords = allDiaries
                .where(
                    (record) => record["userId"] == userId) // 특정 사용자 데이터만 필터링
                .map((record) {
              return {
                "id": record["id"].toString(),
                "userId": record["userId"].toString(),
                "counsel": record["counsel"] ?? {},
                "date": record['date'] != null
                    ? DateFormat('MM월 dd일')
                        .format(DateTime.parse(record['date']))
                    : "N/A",
                "dateTime": record['date'] != null
                    ? DateFormat('a hh시 mm분')
                        .format(DateTime.parse(record['date']))
                    : "N/A",
                "picture": record["picture"] ?? [],
                "category": (record["category"] as List<dynamic>?)
                        ?.map<String>((e) => e.toString())
                        .toList() ??
                    [],
                "score": record["score"] ?? 0,
                "isExpected": record["isExpected"] ?? false,
                "title": record["title"] ?? "제목 없음",
                "content": record["content"] ?? "내용 없음",
              };
            }).toList();
          });

          print("✅ 필터링된 panicRecords: $panicRecords");
        }
      } else {
        throw Exception("❌ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ home_main API 요청 실패: $e");
      setState(() {
        panicRecords = []; // 데이터 오류 시 비어 있는 리스트로 초기화
      });
    }
  }

  void _onCategoryChanged(String category) {
    print("선택된 카테고리: $category");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF375E43), Color(0xFF3A413B)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            MonthlyPanicCount(count: panicRecords.length),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: CategoryFilter(onCategorySelected: _onCategoryChanged),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 360,
                child: panicRecords.isEmpty
                    ? Center(
                        child: Text(
                          "아직 기록이 없습니다 😊",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ) // ✅ 데이터가 없을 경우, "아직 기록이 없습니다." 메시지 표시
                    : PanicList(panicRecords: panicRecords),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  String selectedCategory = "전체";

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');
    final encodedName = prefs.getString('name');

    setState(() {
      _userId = id ?? "Unknown ID";
      _userName = (encodedName != null)
          ? utf8.decode(base64Decode(encodedName))
          : "Unknown User";
    });

    print("userId: $_userId");
    print("userName: $_userName");
  }

  List<Map<String, dynamic>> panicRecords = []; // 데이터를 저장할 리스트
  List<Map<String, dynamic>> filteredRecords = []; // 필터링된 데이터 리스트

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      _loadPanicRecords(); // JSON 데이터 불러오기
    });
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
                    ? DateFormat('yy.MM.dd')
                        .format(DateTime.parse(record['date']))
                    : "N/A",
                "dateTime": record['date'] != null
                    ? DateFormat('a hh시 mm분')
                        .format(DateTime.parse(record['date']))
                    : "N/A",
                "imageUrl": record["imageUrl"] ?? [],
                "category": (record["category"] as List<dynamic>?)
                        ?.map<String>((e) => e.toString())
                        .toList() ??
                    [],
                "score": record["score"] ?? 0,
                "expected": record["expected"] ?? false,
                "title": record["title"] ?? "제목 없음",
                "content": record["content"] ?? "내용 없음",
              };
            }).toList();

            // 카테고리 필터링
            filteredRecords = selectedCategory == "전체"
                ? panicRecords
                : panicRecords
                    .where((record) => record["category"]
                        .contains(selectedCategory)) // 선택된 카테고리로 필터링
                    .toList();
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
    setState(() {
      selectedCategory = category;
      // 선택된 카테고리에 맞게 필터링
      filteredRecords = selectedCategory == "전체"
          ? panicRecords
          : panicRecords
              .where((record) => record["category"].contains(selectedCategory))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(userName: _userName),
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
          // 전체 화면 스크롤
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                MonthlyPanicCount(count: panicRecords.length),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: CategoryFilter(onCategorySelected: _onCategoryChanged),
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 400,
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
                        : PanicList(panicRecords: filteredRecords),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
  bool isLoading = true;
  bool hasError = false;

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

    // print("userId: $_userId");
    // print("userName: $_userName");
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
    final String userId = _userId;

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/diary/user?id=$userId"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<dynamic> allDiaries = jsonData['diaries'] ?? [];

        setState(() {
          isLoading = false;
          panicRecords = allDiaries
              .where((record) => record["userId"] == userId)
              .map((record) => {
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
                  })
              .toList();

          filteredRecords = selectedCategory == "전체"
              ? panicRecords
              : panicRecords
                  .where(
                      (record) => record["category"].contains(selectedCategory))
                  .toList();
        });
      } else {
        throw Exception("서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        panicRecords = [];
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF375E43), Color(0xFF3A413B)],
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonthlyPanicCount(count: panicRecords.length),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: CategoryFilter(onCategorySelected: _onCategoryChanged),
                ),
                SizedBox(height: 30),
                panicRecords.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 100),
                          child: Text(
                            isLoading
                                ? "기록을 불러오는 중입니다..." // 로딩 중
                                : hasError
                                    ? "서버에서 데이터를 가져오지 못했습니다 😢" // 오류
                                    : "아직 기록이 없습니다 😊", // 정상이나 데이터 없음
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 400,
                        child: PanicList(panicRecords: filteredRecords),
                      ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

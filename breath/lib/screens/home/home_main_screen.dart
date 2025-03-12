import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // JSON 로드용 패키지
import './components/category_filter.dart';
import './components/panic_list.dart';
import './components/custom_app_bar.dart';
import './components/monthly_panic_count.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/panic_records.json');
      List<dynamic> jsonData = json.decode(jsonString);

      print("📢 로드된 JSON 데이터: $jsonData"); // JSON 데이터 출력

      setState(() {
        panicRecords = jsonData.map((record) {
          return {
            "id": record["id"].toString(),
            "userId": record["userId"].toString(),
            "counselId": record["counselId"].toString(),
            "date": record['date'] != null
                ? DateTime.parse(record['date'])
                    .toString()
                    .split(" ")[0] // 날짜 변환
                : "N/A",
            "picture": record["picture"] ?? [],
            "category": record["category"] is String
                ? record["category"].split(', ') // 쉼표로 나눠서 리스트 변환
                : List<String>.from(record["category"] ?? []), // JSON 배열 처리
            "score": record["score"] is int
                ? record["score"]
                : int.tryParse(record["score"].toString()) ?? 0, // 정수 변환
            "title": record["title"].toString(),
            "content": record["content"].toString(),
          };
        }).toList();
      });

      print("✅ 변환된 panicRecords: $panicRecords"); // 변환된 데이터 출력
    } catch (e) {
      print("❌ JSON 로딩 오류: $e");
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
        child: panicRecords.isEmpty
            ? Center(
                child: CircularProgressIndicator()) // ✅ 데이터 로딩 중일 때 로딩 인디케이터 표시
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  MonthlyPanicCount(count: panicRecords.length),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child:
                        CategoryFilter(onCategorySelected: _onCategoryChanged),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 360,
                      child: PanicList(panicRecords: panicRecords),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

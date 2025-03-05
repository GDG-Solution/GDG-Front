import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // JSON 로드용 패키지
import './components/category_filter.dart';
import './components/panic_list.dart';
import './components/custom_app_bar.dart';
import './components/monthly_panic_count.dart';

class HomeMainScreen extends StatefulWidget {
  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  List<Map<String, dynamic>> panicRecords = []; // 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    _loadPanicRecords(); // JSON 데이터 불러오기
  }

  Future<void> _loadPanicRecords() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/panic_records.json');
      List<dynamic> jsonData = json.decode(jsonString);

      print("📢 로드된 JSON 데이터: $jsonData"); // ✅ JSON 데이터 출력

      setState(() {
        panicRecords = jsonData.map((record) {
          return {
            "id": record["id"].toString(),
            "userId": record["userId"].toString(),
            "counselId": record["counselId"].toString(),
            "date": record['date'] != null
                ? DateTime.parse(record['date'])
                    .toString()
                    .split(" ")[0] // 변환 적용
                : "N/A",
            "picture": record["picture"] ?? [],
            "category":
                List<String>.from(record["category"]), // List<String> 변환
            "score": record["score"] as int, // int 변환
            "title": record["title"].toString(),
            "content": record["content"].toString(),
          };
        }).toList();
      });

      print("✅ 변환된 panicRecords: $panicRecords"); // ✅ 변환된 데이터 출력
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

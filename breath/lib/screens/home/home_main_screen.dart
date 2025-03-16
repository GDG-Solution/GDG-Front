import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // JSON 로드용 패키지
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  // Future<void> _loadPanicRecords() async {
  //   try {
  //     String jsonString =
  //         await rootBundle.loadString('assets/data/panic_records.json');
  //     List<dynamic> jsonData = json.decode(jsonString);

  //     print("📢 로드된 JSON 데이터: $jsonData"); // ✅ JSON 데이터 출력

  //     setState(() {
  //       panicRecords = jsonData.map((record) {
  //         return {
  //           "id": record["id"].toString(),
  //           "userId": record["userId"].toString(),
  //           "counselId": record["counselId"].toString(),
  //           "date": record['date'] != null
  //               ? DateTime.parse(record['date'])
  //                   .toString()
  //                   .split(" ")[0] // 변환 적용
  //               : "N/A",
  //           "picture": record["picture"] ?? [],
  //           "category":
  //               List<String>.from(record["category"]), // List<String> 변환
  //           "score": record["score"] as int, // int 변환
  //           "title": record["title"].toString(),
  //           "content": record["content"].toString(),
  //         };
  //       }).toList();
  //     });

  //     print("✅ 변환된 panicRecords: $panicRecords"); // ✅ 변환된 데이터 출력
  //   } catch (e) {
  //     print("❌ JSON 로딩 오류: $e");
  //   }
  // }

  Future<void> _loadPanicRecords() async {
    final String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
    final String userId = "test"; // ✅ 특정 사용자 ID (임시값)
    //final String userId = prefs.getString('userId');

    try {
      final response =
          await http.get(Uri.parse("$baseUrl/diary/user?id=$userId"));

      print("✅ 서버 응답 상태 코드: ${response.statusCode}");
      print("✅ 서버 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> allDiaries =
            jsonData['diaries']; // ✅ API 응답에서 diaries 리스트 추출

        setState(() {
          panicRecords = allDiaries
              .where(
                  (record) => record["userId"] == userId) // ✅ 특정 사용자 데이터만 필터링
              .map((record) {
            return {
              "id": record["id"].toString(),
              "userId": record["userId"].toString(),
              "counsel": record["counsel"] ?? "N/A",
              "date": record['date'] != null
                  ? DateTime.parse(record['date']).toString().split(" ")[0]
                  : "N/A",
              "picture": record["picture"] ?? [],
              "category": List<String>.from(record["category"] ?? []),
              "score": record["score"] as int,
              "title": record["title"].toString(),
              "content": record["content"].toString(),
            };
          }).toList();
        });

        print("✅ 필터링된 panicRecords: $panicRecords");
      } else {
        throw Exception("❌ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ home_main API 요청 실패: $e");
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

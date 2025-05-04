import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // JSON 로드용 패키지
import './components/category_filter.dart';
import './components/panic_list.dart';
import './components/custom_app_bar.dart';
import './components/monthly_panic_count.dart';
import '../../services/api_service.dart';

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

// 서버에서 panicRecords를 요청하는 함수
  Future<void> _loadPanicRecords() async {
    final String userId = "Aodwns";

    try {
      List<Map<String, dynamic>> records =
          await ApiService.fetchPanicRecords(userId);

      print("📢 로드된 데이터: $records"); // 데이터 출력

      setState(() {
        panicRecords = records; // 서버에서 받은 데이터로 panicRecords 갱신
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

import 'package:breath/service/api_record_list.dart';
import 'package:flutter/material.dart';
import 'package:breath/service/api_record_list.dart';

import 'components/detail_header.dart';
import 'components/detail_record_list.dart';

class DetailScreen extends StatefulWidget {
  final String panicId; // 특정 공황 기록을 불러오기 위한 ID

  const DetailScreen({Key? key, required this.panicId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? selectedRecord; // 선택된 다이어리 데이터
  List<Map<String, dynamic>> recordsForSameDate = []; // 같은 날짜의 여러 기록 저장
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    loadPanicRecord(); // API 데이터 로드
  }

  // API 호출하여 공황 기록 데이터 가져오기
  Future<void> loadPanicRecord() async {
    try {
      final record = await ApiRecordList.fetchPanicRecordById(widget.panicId);
      print("✅ API 응답 데이터: $record"); // API에서 받아온 데이터 출력
      if (record.isNotEmpty) {
        setState(() {
          selectedRecord = {
            "id": record["id"] ?? "",
            "userId": record["userId"] ?? "",
            "counsel": record["counsel"] ?? {},
            "date": record["date"] ?? "",
            "picture": record["picture"] ?? [],
            "category": List<String>.from(record["category"] ?? []),
            "score": record["score"] ?? 0,
            "title": record["title"] ?? "",
            "content": record["content"] ?? "",
          };

          // 같은 날짜의 모든 기록을 필터링 (API에서 가져와야 정확함)
          recordsForSameDate = [selectedRecord!];

          isLoading = false; // 데이터 로딩 완료
        });
      }
    } catch (e) {
      print("❌ detail screen API 호출 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 데이터 로딩 중
          : Stack(
              children: [
                // 배경
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
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
                // 전체 화면 스크롤
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 커스텀 헤더
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "기록 분석",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.white),
                              onPressed: () {
                                // 캘린더 기능 추가 가능
                              },
                            ),
                          ],
                        ),
                      ),

                      // 헤더 (날짜 정보)
                      const DetailHeader(),
                      const SizedBox(height: 8),

                      // 같은 날짜의 모든 기록을 수평 스크롤로 표시
                      DetailRecordList(records: recordsForSameDate),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

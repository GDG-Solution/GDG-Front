import 'package:breath/service/api_record_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/detail_header.dart';
import 'components/detail_image.dart';
import '../../../components/tag_list.dart';
import 'components/detail_intensity.dart';
import 'components/detail_record.dart';
import 'components/detail_call_alert.dart';
import 'components/custom_detail_app_bar.dart';

class DetailScreen extends StatefulWidget {
  final String panicId; // 특정 공황 기록을 불러오기 위한 ID

  const DetailScreen({Key? key, required this.panicId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? selectedRecord; // 선택된 다이어리 데이터
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    loadPanicRecord(); // API 데이터 로드
  }

  // 날짜 변환 함수 1 (yy년 MM월 dd일)
  String formatDate1(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) return "날짜 없음";

      DateTime date = DateTime.parse(dateString);

      // "yy년 MM월 dd일" 형태로 변환
      String formattedDate = DateFormat("yy년 MM월 dd일").format(date);
      return formattedDate;
    } catch (e) {
      return "날짜 없음"; // 날짜 변환 실패 시 기본값
    }
  }

  // 날짜 변환 함수 2 (a hh:mm, MM.dd)
  String formatDate2(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) return "날짜 없음";

      DateTime date = DateTime.parse(dateString);

      // "오전 --, MM.dd." 형태로 변환
      String formattedDate = DateFormat("a hh:mm, MM.dd").format(date);
      return formattedDate;
    } catch (e) {
      return "날짜 없음"; // 날짜 변환 실패 시 기본값
    }
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
            "expected": record["expected"] ?? false,
            "title": record["title"] ?? "",
            "content": record["content"] ?? "",
          };

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
      appBar: CustomDetailAppBar(title: "기록 분석"),
      extendBodyBehindAppBar: true,
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
                      SizedBox(height: 50),
                      // ✅ 커스텀 헤더
                      DetailHeader(
                        date: formatDate1(selectedRecord?["date"]),
                      ),
                      const SizedBox(height: 16),

                      // ✅ 이미지
                      DetailImage(
                        imageUrl: (selectedRecord?["picture"] as List<dynamic>?)
                                    ?.isNotEmpty ==
                                true
                            ? selectedRecord!["picture"][0]
                            : "https://source.unsplash.com/400x200/?city,people",
                      ),

                      const SizedBox(height: 16),

                      // ✅ 카테고리 태그
                      TagList(
                        tags: selectedRecord?["category"] != null
                            ? (selectedRecord?["category"] as List<dynamic>)
                                .map<String>((tag) => tag.toString())
                                .toList()
                            : [],
                      ),

                      const SizedBox(height: 16),

                      // ✅ 제목 + 날짜
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedRecord?["title"] ?? "제목 없음",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${formatDate2(selectedRecord?["date"])} 작성" ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ✅ 공포 수치 + 예상 여부
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DetailIntensity(
                              intensity: selectedRecord?["score"] ?? 0),
                          Text(
                            selectedRecord?["expected"] == true
                                ? "예상됨"
                                : "예상되지 않음",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ✅ 상세 기록 내용
                      DetailRecordMemo(
                        memoText: selectedRecord?["content"] ?? "내용 없음",
                      ),

                      const SizedBox(height: 16),

                      // ✅ 상담 통화 시간 (있을 경우 표시)
                      if (selectedRecord?["counsel"] != null &&
                          selectedRecord!["counsel"]["seconds"] != null)
                        DetailCallAlert(
                          callDurationSeconds: selectedRecord!["counsel"]
                              ["seconds"],
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

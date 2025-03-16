import 'package:breath/service/api_record_list.dart';
import 'package:flutter/material.dart';
import 'package:breath/service/api_record_list.dart';
import 'package:intl/intl.dart';

import 'components/detail_header.dart';
import 'components/detail_image.dart';
import '../../../components/tag_list.dart';
import 'components/detail_intensity.dart';
import 'components/detail_record.dart';
import 'components/detail_call_alert.dart';

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

  // 날짜 변환 함수
  String formatDate(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) return "날짜 없음";
      DateTime date = DateTime.parse(dateString);
      return DateFormat("yy년 M월 d일").format(date); // "24년 7월 21일" 형식으로 변환
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
                      // ✅ 커스텀 헤더
                      DetailHeader(
                        date: formatDate(selectedRecord?["date"]),
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
                            "작성 날짜: ${selectedRecord?["date"] ?? ""}",
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
                          // DetailPredictionToggle(
                          //   isPredicted: isPredicted,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       isPredicted = value;
                          //     });
                          //   },
                          //),
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

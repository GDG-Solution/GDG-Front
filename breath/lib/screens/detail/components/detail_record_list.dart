import 'package:flutter/material.dart';
import 'detail_image.dart';
import '../../../components/tag_list.dart';
import 'detail_intensity.dart';
import 'detail_record.dart';
import 'detail_call_alert.dart';

class DetailRecordList extends StatelessWidget {
  final List<Map<String, dynamic>> records; // 같은 날짜의 여러 기록 리스트

  const DetailRecordList({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500, // 카드 높이 설정
      child: PageView.builder(
        itemCount: records.length,
        scrollDirection: Axis.horizontal, // 수평 스크롤
        itemBuilder: (context, index) {
          final record = records[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지
                  DetailImage(
                    imageUrl: record['picture'].isNotEmpty
                        ? record['picture'][0]
                        : "https://source.unsplash.com/400x200/?city,people",
                  ),
                  const SizedBox(height: 16),

                  // 태그 리스트
                  TagList(tags: List<String>.from(record['category'])),
                  const SizedBox(height: 16),

                  // 공포 수치
                  DetailIntensity(intensity: record['score']),
                  const SizedBox(height: 16),

                  // 기록 메모
                  DetailRecordMemo(memoText: record['content']),
                  const SizedBox(height: 16),

                  // 통화 시간 (임시값)
                  DetailCallAlert(callDurationSeconds: 330),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

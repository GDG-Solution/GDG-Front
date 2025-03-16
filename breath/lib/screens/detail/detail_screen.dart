import 'package:flutter/material.dart';

import 'components/detail_header.dart';
import 'components/detail_image.dart';
import '../../components/tag_list.dart';
import 'components/detail_intensity.dart';
import 'components/detail_record.dart';
import 'components/detail_call_alert.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageUrlFromBackend =
        "https://source.unsplash.com/400x200/?city,people";
    final List<String> tagsFromBackend = ["호흡곤란", "식은땀", "두통"];
    final int intensityFromBackend = 3;
    final String memoFromBackend = "점점 공황이 약해지는 것 같다. 언제간 공황이 없어졌으면 좋겠다. "
        "특이하게 점점 이번처럼 자주 숨 가쁨 증상이 오지 않고 호흡곤란이 와서 매우 놀랐다.";
    final int callDurationFromBackend = 330; // 330초 (5분 30초)

    return Scaffold(
      body: Stack(
        // Stack을 사용하여 배경과 컨텐츠를 분리
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                const DetailHeader(),
                const SizedBox(height: 8),
                DetailImage(imageUrl: imageUrlFromBackend),
                const SizedBox(height: 16),
                TagList(tags: tagsFromBackend),
                const SizedBox(height: 16),
                DetailIntensity(intensity: intensityFromBackend),
                const SizedBox(height: 16),
                DetailRecordMemo(memoText: memoFromBackend),
                const SizedBox(height: 16),
                DetailCallAlert(callDurationSeconds: callDurationFromBackend),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

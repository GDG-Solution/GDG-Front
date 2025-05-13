import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../components/pain_level_dots.dart';
import '../../detail/detail_screen.dart';

class PanicCard extends StatelessWidget {
  final String panicId;
  final String? imageUrl; // /images/xxx.jpg 형식이거나 null
  final String title;
  final String description;
  final int time;
  final String date;
  final String dateTime;
  final String day;
  final List<String> category;
  final int painRate;

  const PanicCard({
    required this.panicId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.dateTime,
    required this.day,
    required this.category,
    required this.painRate,
  });

  // 초를 "MM:SS" 형식으로 변환하는 함수
  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return "$formattedMinutes:$formattedSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = imageUrl != null && imageUrl!.isNotEmpty;
    final String finalImageUrl = hasValidImage
        ? "${dotenv.env['API_BASE_URL']}$imageUrl"
        : "assets/images/card/no_photo.png";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(panicId: panicId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 & 공포 점수
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(date,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  PainLevelDots(painRate: painRate),
                ],
              ),
              SizedBox(height: 16),

              // ✅ 이미지 공간
              Container(
                width: double.infinity,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: hasValidImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          finalImageUrl,
                          width: double.infinity,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          finalImageUrl,
                          width: double.infinity,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: 20),

              // ✅ 카테고리
              _buildCategoryTags(),

              SizedBox(height: 6),

              // 제목
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),

              // 설명
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff626262),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 14),

              // 통화 아이콘 + 시간
              Row(
                children: [
                  Image.asset(
                    "assets/icons/home/call_icon.png",
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 3.5),
                  Text(formatDuration(time),
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTags() {
    List<Widget> tagWidgets = [];
    double currentWidth = 0.0;
    const double maxWidth = 200.0;

    for (String tag in category) {
      TextPainter painter = TextPainter(
        text: TextSpan(
          text: tag,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();

      double tagWidth = painter.width + 24;

      if (currentWidth + tagWidth > maxWidth) {
        int remainingCount = category.length - tagWidgets.length;
        if (remainingCount > 0) {
          tagWidgets.add(_buildTag("+ 외 $remainingCount 개"));
        }
        break;
      }

      tagWidgets.add(_buildTag(tag));
      currentWidth += tagWidth;
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 0,
      children: tagWidgets,
    );
  }

  Widget _buildTag(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: Color(0xffE1F8CC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff275220)),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRecordList {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? "";

  // 공황 기록 리스트 가져오기 (GET 요청)
  static Future<List<Map<String, dynamic>>> fetchPanicRecords() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/diary"));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        // JSON 데이터를 Map<String, dynamic> 리스트로 변환
        return jsonData.map((record) {
          return {
            "id": record["id"].toString(),
            "userId": record["userId"].toString(),
            "counselId": record["counselId"].toString(),
            "date": record['date'] ?? "N/A",
            "picture": record["picture"] ?? [],
            "category": List<String>.from(record["category"]),
            "score": record["score"] as int,
            "title": record["title"].toString(),
            "content": record["content"].toString(),
          };
        }).toList();
      } else {
        throw Exception("❌ 서버 오류: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API 요청 실패: $e");
      return [];
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRecordList {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  // 특정 panicId로 데이터 가져오기 -> 상세 페이지에서 해당 상담 내역 모두
  static Future<Map<String, dynamic>> fetchPanicRecordById(
      String panicId) async {
    final url = Uri.parse("$baseUrl/diary?id=$panicId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        final decodedData = json.decode(decodedBody);

        return decodedData;
      } else {
        throw Exception("데이터 로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("api_record_list API 호출 에러: $e");
    }
  }
}

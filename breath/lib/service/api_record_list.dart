import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRecordList {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ?? 'http://default-url.com';

  // 특정 panicId로 데이터 가져오기
  static Future<Map<String, dynamic>> fetchPanicRecordById(
      String panicId) async {
    final url = Uri.parse("$baseUrl/diary?id=$panicId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("데이터 로드 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("api_record_list API 호출 에러: $e");
    }
  }
}

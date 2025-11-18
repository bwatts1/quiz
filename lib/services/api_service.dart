import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  // Base URL for Open Trivia DB
  static const String _base = 'https://opentdb.com/api.php';

  static Future<List<Question>> fetchQuestions({
    int amount = 10,
    int? category,
    String? difficulty,
    String? type = 'multiple',
  }) async {
    final buffer = StringBuffer('$_base?amount=$amount');
    if (category != null) buffer.write('&category=$category');
    if (difficulty != null) buffer.write('&difficulty=$difficulty');
    if (type != null) buffer.write('&type=$type');

    final url = Uri.parse(buffer.toString());
    final resp = await http.get(url);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load questions (status ${resp.statusCode})');
    }

    final Map<String, dynamic> jsonBody = json.decode(resp.body);
    final int responseCode = (jsonBody['response_code'] as int);

    if (responseCode != 0) {
      throw Exception('API returned response_code $responseCode');
    }

    final List<dynamic> results = jsonBody['results'] as List<dynamic>;
    return results.map((r) => Question.fromJson(r as Map<String, dynamic>)).toList();
  }
}

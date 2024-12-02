import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://opentdb.com/api.php';

  Future<List<Map<String, dynamic>>> fetchQuestions(
      {required int amount,
      required int category,
      required String difficulty,
      required String type}) async {
    // Construct the URL with parameters based on user's choices
    String url =
        '$apiUrl?amount=$amount&category=$category&difficulty=$difficulty&type=$type';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final url = 'https://opentdb.com/api_category.php';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['trivia_categories']);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
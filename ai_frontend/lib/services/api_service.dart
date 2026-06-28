import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String defaultBaseUrl = 'http://10.0.2.2:8000';
  final String baseUrl;
  final http.Client _client;

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? defaultBaseUrl, _client = http.Client();

  Future<ChatResponse> sendMessage(ChatRequest request) async {
    try {
      final response = await _client.post(Uri.parse('$baseUrl/chat'), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: jsonEncode(request.toJson())).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) return ChatResponse.fromJson(jsonDecode(response.body));
      throw ApiException('Failed to send message', statusCode: response.statusCode, message: response.body);
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String error;
  final int? statusCode;
  final String? message;
  ApiException(this.error, {this.statusCode, this.message});
  @override
  String toString() => statusCode != null ? 'ApiException: $error (Status: $statusCode)' : 'ApiException: $error';
}
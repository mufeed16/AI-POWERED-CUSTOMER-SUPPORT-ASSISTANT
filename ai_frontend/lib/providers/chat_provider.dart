import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

enum ChatState { idle, loading, success, error }

class ChatProvider extends ChangeNotifier {
  final ApiService _apiService;
  ChatState _state = ChatState.idle;
  List<Message> _messages = [];
  String? _errorMessage;
  ChatResponse? _lastResponse;

  ChatProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  ChatState get state => _state;
  List<Message> get messages => List.unmodifiable(_messages);
  String? get errorMessage => _errorMessage;
  ChatResponse? get lastResponse => _lastResponse;
  bool get isLoading => _state == ChatState.loading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (_state == ChatState.loading) return;
    _messages.add(Message(role: 'user', content: text));
    notifyListeners();
    _state = ChatState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final history = _messages.take(_messages.length - 1).toList();
      final response = await _apiService.sendMessage(ChatRequest(message: text, conversationHistory: history));
      _messages.add(Message(role: 'assistant', content: response.message, uiType: response.uiType, data: response.data));
      _lastResponse = response;
      _state = ChatState.success;
      _errorMessage = null;
    } on ApiException catch (e) {
      _state = ChatState.error;
      _errorMessage = e.toString();
      _messages.add(Message(role: 'assistant', content: 'Error: ${e.error}. Check if backend is running.', uiType: 'message'));
    } catch (e) {
      _state = ChatState.error;
      _errorMessage = 'Unexpected error: $e';
      _messages.add(Message(role: 'assistant', content: 'An unexpected error occurred.', uiType: 'message'));
    }
    notifyListeners();
  }

  void clearHistory() {
    _messages.clear();
    _lastResponse = null;
    _errorMessage = null;
    _state = ChatState.idle;
    notifyListeners();
  }

  Future<void> retry() async {
    if (_messages.isEmpty) return;
    final lastUserMessage = _messages.lastWhere((m) => m.role == 'user', orElse: () => Message(role: 'user', content: ''));
    if (lastUserMessage.content.isNotEmpty) {
      if (_messages.isNotEmpty && _messages.last.role == 'assistant') _messages.removeLast();
      await sendMessage(lastUserMessage.content);
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
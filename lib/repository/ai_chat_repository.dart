import 'package:flutter_chatgptapi_sample/config/chatgpt_config.dart';

import '../model/chat_message.dart';
import '../network/api_service.dart';

/// AI Chatのリポジトリ
class AiChatRepository {
  final String _chatGptApiDomain = 'api.openai.com';
  final String _chatGptApiPath = 'v1/chat/completions';
  final String _chatGptModel = 'gpt-3.5-turbo';
  final ApiService _apiService = ApiService();

  /// AIからの回答を取得する
  Future<String?> getAiAnswer(List<ChatMessage> chatMessages) async {
    String? returnValue;
    final List<Map<String, String>> messages = [];

    try {
      for (final ChatMessage chatMessage in chatMessages) {
        messages.add(
            {'role': chatMessage.role.name, 'content': chatMessage.message});
      }

      final apiKeys = ChatGptConfig.getApiKeys();

      final response = await _apiService.postJson(
        _chatGptApiDomain,
        _chatGptApiPath,
        apiKeys,
        {
          'model': _chatGptModel,
          'messages': messages,
        },
      );

      if (response != null) {
        returnValue = response['choices'][0]['message']['content'].toString();
      }

      return returnValue;
    } catch (e) {
      rethrow;
    }
  }
}

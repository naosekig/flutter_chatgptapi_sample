import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGptConfig {
  static String getApiKeys() {
    return dotenv.env['API_KEYS']!;
  }
}

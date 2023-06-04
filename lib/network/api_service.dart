import 'dart:convert';

import 'package:http/http.dart' as http;

/// APIとアクセスする為のサービス
class ApiService {
  /// JSONをPOSTする
  Future<Map<dynamic, dynamic>?> postJson(String domain, String path,
      String token, Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.https(domain, path),
          headers: {
            'content-type': 'application/json',
            'authorization': 'Bearer $token'
          },
          body: json.encode(body));
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    } catch (e) {
      rethrow;
    }
  }
}

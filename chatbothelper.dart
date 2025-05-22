// lib/wit_ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class WitAiService {
  final String witToken = "Bearer TMXVANWKNGW52HB7MFPGZ6KBCALOFD7K";  // Replace with your token

  Future<Map<String, dynamic>> detectIntent(String message) async {
    final url = Uri.parse("https://api.wit.ai/message?v=20250425&q=${Uri.encodeComponent(message)}");
    
    try {
      final response = await http.get(url, headers: {
        "Authorization": witToken,
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);  // Return the JSON response
      } else {
        return {"error": "Failed to detect intent"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}

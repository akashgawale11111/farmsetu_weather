import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = "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";

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a farming expert helping Indian farmers."
          },
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.body}";
    }
  }
}
import 'dart:convert';
import 'package:farmsetu_weather/services/constants.dart';
import 'package:http/http.dart' as http;


class AIService {
  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(Constants.baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Constants.apiKey}"
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content": "You are a farming expert helping Indian farmers."
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
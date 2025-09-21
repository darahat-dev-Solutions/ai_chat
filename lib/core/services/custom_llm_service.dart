import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// CustomLlmService LLM Service implementation
class CustomLlmService {
  ///AI_API_KEY you may find in .env
  static final _apiKey = dotenv.env['AI_API_KEY'];
  static final _endpoint = dotenv.env['CUSTOM_LLM_ENDPOINT'] ??
      'https://openrouter.ai/api/v1/chat/completions';
  static final _model =
      dotenv.env['CUSTOM_LLM_model'] ?? "mistralai/mistral-7b-instruct:free";

  /// CustomLlmService Service constructor
  CustomLlmService() {
    if (_apiKey == null) {
      throw Exception('AI_API_KEY is not set in the .env file');
    } else {}
  }

  /// CustomLlmService LLM API calling procedure as like as regular jquery
  Future<String> generateSummary(String taskList) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer':
            dotenv.env['OPENROUTER_HTTP_REFERER'] ?? 'http://localhost',
        'X-Title': dotenv.env['OPENROUTER_APP_TITLE'] ?? 'ai_chat',
      },
      body: jsonEncode({
        "model": _model,
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant that generates task summaries and plans.",
          },
          {
            "role": "user",
            "content":
                "Based on the following task list, generate a summary and suggest smart daily plan:\n$taskList",
          },
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception(
        'Failed to get response from LLM: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Generate quick reply like as chat for ai chat features
  Future<String> generateQuickReply(
    String userMessage,
    String systemPrompt,
    String userPromptPrefix,
    String errorCustomLlmRequest,
  ) async {
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'Referer': dotenv.env['OPENROUTER_HTTP_REFERER'] ?? 'http://localhost',
      'Origin': dotenv.env['OPENROUTER_HTTP_REFERER'] ?? 'http://localhost',
      'X-Title': dotenv.env['OPENROUTER_APP_TITLE'] ?? 'ai_chat',
    };

    final bodyMap = {
      "model": _model,
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userMessage},
      ],
      "temperature": 0.7, // Lower for stricter adherence to systemPrompt
      "max_tokens": 800,
    };

    // Mask API key for safe debugging
    final maskedKey = _apiKey == null
        ? 'null'
        : (_apiKey!.length > 12 ? '${_apiKey!.substring(0, 8)}****' : '****');

    print(
        'Request headers (no Authorization): ${Map.from(headers)..remove('Authorization')}');
    print('Authorization: Bearer $maskedKey');
    print('Request body: ${jsonEncode(bodyMap)}');

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: headers,
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception(
        'Failed to get response: ${response.statusCode} ${response.body}',
      );
    }
  }
}

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
  static final _model = dotenv.env['CUSTOM_LLM_MODEL'] ?? "x-ai/grok-4-fast";

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
  Future<String> generateResponse(
    String systemPrompt,
  ) async {
    return _makeLlmCall(systemPrompt);
  }

  /// Private helper for making the actual HTTP request
  Future<String> _makeLlmCall(
    String systemPrompt,
  ) async {
    final headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'Referer': dotenv.env['OPENROUTER_HTTP_REFERER'] ?? 'http://localhost',
      'Origin': dotenv.env['OPENROUTER_HTTP_REFERER'] ?? 'http://localhost',
      'X-Title': dotenv.env['OPENROUTER_APP_TITLE'] ?? 'ai_chat',
    };
    final body = {
      "model": _model,
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": "Proceed with the instructions above."},
      ],
      "temperature": 0.7, // Lower for stricter adherence to systemPrompt
      "max_tokens": 800,
    };

    // Lightweight debug logging (masks API key) to help diagnose endpoint/model errors
    try {
      final maskedKey = _apiKey == null
          ? 'null'
          : (_apiKey!.length > 12
              ? '${_apiKey!.substring(0, 8)}****${_apiKey!.substring(_apiKey!.length - 4)}'
              : '****');

      // Print request details (safe for development) without exposing the full API key
      print('LLM Request -> endpoint: $_endpoint');
      print('LLM Request -> model: $_model');
      print(
          'LLM Request -> headers (without Authorization): ${Map.from(headers)..remove('Authorization')}');
      print('LLM Request -> Authorization: Bearer $maskedKey');
      print('LLM Request -> body: ${jsonEncode(body)}');
    } catch (_) {
      // ignore debug logging errors
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    // Print response for debugging
    try {
      print('LLM Response -> status: ${response.statusCode}');
      print('LLM Response -> body: ${response.body}');
    } catch (_) {
      // ignore debug logging errors
    }

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } on FormatException catch (e) {
        throw Exception(
          'Failed to parse JSON response: $e, \nResponse body: ${response.body}',
        );
      }
    } else {
      throw Exception(
        'Failed to get response: ${response.statusCode} ${response.body}',
      );
    }
  }
}

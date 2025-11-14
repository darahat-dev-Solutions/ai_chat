import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// CustomLlmService LLM Service implementation
class CustomLlmService {
  static final _apiKey = dotenv.env['AI_API_KEY'];
  static final _endpoint = dotenv.env['CUSTOM_LLM_ENDPOINT'] ??
      'https://openrouter.ai/api/v1/chat/completions';
  static final _model = dotenv.env['CUSTOM_LLM_MODEL'] ??
      'nousresearch/hermes-3-llama-3.1-405b:free'; // Remove the hardcoded fallback

  /// CustomLlmService Service constructor

  CustomLlmService() {
    if (_apiKey == null) {
      throw Exception('AI_API_KEY is not set in the .env file');
    }

    // Add debug to verify the model is loaded correctly
    print('🔧 DEBUG: LLM Model loaded: $_model');
    print('🔧 DEBUG: LLM Endpoint: $_endpoint');
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
  /// Private helper for making the actual HTTP request
  Future<String> _makeLlmCall(String systemPrompt) async {
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
      "temperature": 0.7,
      "max_tokens": 800,
    };

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      print('LLM Response -> status: ${response.statusCode}');
      print('LLM Response -> body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else if (response.statusCode == 429) {
        // Handle rate limit or free model unavailability
        return "⚠️ The AI service is currently busy or rate-limited. Please wait a moment and try again.\n\n💡 Tip: You can add your own API key in OpenRouter settings to remove this limit:\nhttps://openrouter.ai/settings/integrations";
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Handle invalid or missing API key
        return "🔒 Your AI access key seems invalid or missing. Please check your API key configuration in the app or .env file.";
      } else if (response.statusCode >= 500) {
        // Server-side errors
        return "🚧 The AI server is temporarily unavailable. Please try again later.";
      } else {
        // Generic fallback
        return "❗ Unexpected error: ${response.statusCode}. Please try again later.";
      }
    } catch (e) {
      // Network or JSON parsing errors
      return "⚠️ Unable to reach the AI service. Please check your internet connection or API key configuration.\n\nError: $e";
    }
  }
}

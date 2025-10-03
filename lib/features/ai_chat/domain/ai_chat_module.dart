import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_module.freezed.dart';
part 'ai_chat_module.g.dart';

/// Represents a single AI tools that an AiChatModule can use.
@freezed
class AiChatTool with _$AiChatTool {
  const factory AiChatTool({
    @JsonKey(name: 'tool_name')
    String? toolName, // Maps "tool_name" to toolName
    @JsonKey(name: 'response_prompt')
    String? responsePrompt, // Maps "response_prompt" to responsePrompt
    List<String>? keywords,
  }) = _AiChatTool;

  factory AiChatTool.fromJson(Map<String, dynamic> json) =>
      _$AiChatToolFromJson(json);
}

/// Represents a AI Chat Module
@freezed
class AiChatModule with _$AiChatModule {
  ///Creates an [AiChatModule]
  const factory AiChatModule(
      {required int id,
      required String name,
      required String prompt,
      required String description,
      required List<AiChatTool> tools}) = _AiChatModule;

  /// JSON factory (required for Freezed + json_serializable integration)
  factory AiChatModule.fromJson(Map<String, dynamic> json) =>
      _$AiChatModuleFromJson(json);
}

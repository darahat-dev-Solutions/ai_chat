import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_module.freezed.dart';
part 'ai_chat_module.g.dart';

/// Represents a AI Chat Module
@freezed
class AiChatModule with _$AiChatModule {
  ///Creates an [AiChatModule]
  const factory AiChatModule({
    required int id,
    required String name,
    required String prompt,
    required String description,
  }) = _AiChatModule;

  /// JSON factory (required for Freezed + json_serializable integration)
  factory AiChatModule.fromJson(Map<String, dynamic> json) =>
      _$AiChatModuleFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_chat_module.freezed.dart';
part 'ai_chat_module.g.dart';

/// Represents a single AI Chat Module from the list
@freezed
class AiChatModule with _$AiChatModule {
  const factory AiChatModule({
    required int id,
    required String name,
  }) = _AiChatModule;

  factory AiChatModule.fromJson(Map<String, dynamic> json) =>
      _$AiChatModuleFromJson(json);
}

/// Represents the detailed information for a specific AI chat module

class AiChatModuleDetails with _$AiChatModuleDetails {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AiChatModuleDetails({
    required int id,
    required String name,
    required String description,
    required String prompt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AiChatModuleDetails;

  factory AiChatModuleDetails.fromJson(Map<String, dynamic> json) =>
      _$AiChatModuleDetailsFromJson(json);
}

import 'dart:convert';

import 'package:ai_chat/core/errors/exceptions.dart';
import 'package:ai_chat/core/utils/ai_chat_list_utils.dart';
import 'package:ai_chat/features/ai_chat/domain/ai_chat_module.dart';
import 'package:ai_chat/features/ai_chat/provider/ai_chat_providers.dart';
import 'package:ai_chat/features/ai_chat/provider/popular_items_provider.dart';
import 'package:ai_chat/features/app_settings/provider/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ai_chat_model.dart';

typedef ToolFunction = Future<dynamic> Function();
final toolRegistryProvider = Provider<Map<String, ToolFunction>>((ref) {
  /// Helper function to get popular items. This is an example of a tool's implementation
  Future<dynamic> _getPopularItems() async {
    print('🔧 DEBUG: _getPopularItems function called!');

    /// This function could fetch data from a provider, an API, a database, etc.
    try {
      // Await the FutureProvider's future so we get the real list (not null) or throw on error
      final items = await ref.read(popularItemsProvider.future);
      return items;
    } catch (e) {
      print('🔧 ERROR: Failed to get popular items: $e');
      return <dynamic>[];
    }
  }

  /// To add a new code-executing tool, simply add its name and function to this map.
  /// The controller login does not need to change
  return {
    'get_popular_items': _getPopularItems,
    'get_drinks': _getPopularItems,
    //'book_table': () => ref.read(tableBookingServiceProvider).bookTable(),
    //'check_order_status': (params) => ref.read(orderServiceProvider).getStatus(params['orderId'])
  };
});

/// A Controller class which manages User to AI Chat
class AiChatController extends AsyncNotifier<List<AiChatModel>> {
  /// The `build` method is called once when the notifier is first created
  /// It should return a Future that resolves to the initial state.
  @override
  Future<List<AiChatModel>> build() async {
    final repo = ref.watch(aiChatRepositoryProvider);
    return repo.getAiChat();
  }

  /// Add a new aiChat and reload list
  Future<void> addAiChat(String usersText) async {
    print('💬 DEBUG: User message: "$usersText"');

    /// Retrieves the [repo] instance from its provider
    final repo = ref.read(aiChatRepositoryProvider);

    /// Add new user Text (1.Add the user's message to the UI immediately)
    final usersMessage = await repo.addAiChat(usersText);

    /// If user message is null return nothing
    if (usersMessage == null) return;

    /// Persist the value of [userMessage] to [currentAiChats] local state array .
    state = AsyncValue.data([...state.value ?? [], usersMessage]);

    try {
      final activeModule = ref.read(activeAiModuleProvider);
      final customLlmService = ref.read(customLlmServiceProvider);
      final toolRegistry = ref.read(toolRegistryProvider);

      /// Retrieves the [CustomLlmService] instance from its provider
      String? aiReplyText;

      /// Step 1: Tool Selection ---
      final toolSelectionPrompt = _buildToolSelectionPrompt(
        activeModule,
        usersText,
      );

      /// This call should be to a generic LLM function
      final toolChoiceJson =
          // await customLlmService.generateResponse(toolSelectionPrompt);
          await customLlmService.generateResponse(toolSelectionPrompt);
      String? chosenToolName;

      try {
        /// Expects JSON: {"tool_name" : "some_tool" | null}
        chosenToolName = jsonDecode(toolChoiceJson)['tool_name'];
        print('🔨 DEBUG: Tool chosen: $chosenToolName');
      } catch (e) {
        print(
          'Warning: Could not parse tool choice Json from LLM. Failling back to default chat. Details: $e',
        );
      }

      /// ---- STEP 2: EXECUTION & RESPONSE GENERATION ---
      if (chosenToolName != null && chosenToolName.isNotEmpty) {
        print('🔨 DEBUG: Tool chosen: $chosenToolName');

        final tool = _findToolByName(activeModule, chosenToolName);
        if (tool != null) {
          print('🔨 DEBUG: Tool found in module: ${tool.toolName}');

          /// A valid tool was choosen by the LLM
          dynamic toolResult;

          /// Check the registry to see if this tool has a corresponding Dart function
          if (toolRegistry.containsKey(chosenToolName)) {
            print('🔨 DEBUG: Tool function found in registry, executing...');

            final toolFunction = toolRegistry[chosenToolName]!;
            toolResult = await toolFunction();
            print('🔨 DEBUG: Tool execution completed. Result: $toolResult');
          }

          /// Now, Generate the final response, providing the tool result as context
          final finalResponsePrompt = _buildFinalResponsePrompt(
            activeModule,
            tool,
            usersText,
            toolResult,
          );
          aiReplyText = await customLlmService.generateResponse(
            finalResponsePrompt,
          );
        } else {
          /// The LLM hallucinated a tool name that doesnt exist in the persona's definition
          print(
            'Warning: LLM choose a non-existent tool: "$chosenToolName". Falling back to default chat.',
          );
          aiReplyText = await _runDefaultChat(activeModule, usersText);
        }
      } else {
        aiReplyText = await _runDefaultChat(activeModule, usersText);
      }

      /// Creates a new [usersMessage] instance with updated values
      ///
      /// This is useful for creating a modified copy of the state without
      /// Mutating the original object, which is a best practice for state management.
      final updatedMessage = usersMessage.copyWith(
        replyText: aiReplyText,
        isReplied: true,
        isSeen: true,
      );

      /// Update Message according to Local DB
      await repo.updateAiChat(usersMessage.id!, updatedMessage);

      /// Persist State
      state = AsyncValue.data(
        state.value!.updated(usersMessage.id!, updatedMessage),
      );
    } catch (e, s) {
      throw ServerException(
        '🚀 ~Save on hive of LLM reply from (ai_chat_controller.dart) $e and this is $s',
      );
    }
  }

  /// Fallback method for running a default conversation when no tool is needed
  Future<String> _runDefaultChat(AiChatModule module, String userQuery) async {
    final customLlmService = ref.read(customLlmServiceProvider);
    final defaultPrompt = _buildDefaultPrompt(module, userQuery);
    return await customLlmService.generateResponse(defaultPrompt);
  }

  String _buildToolSelectionPrompt(AiChatModule module, String userQuery) {
    final toolsList = module.tools
        .map((t) => '- "${t.toolName}": ${t.responsePrompt}')
        .join('\n');
    print('🔍 DEBUG: Active module: ${module.name}');
    print('🔍 DEBUG: User query: "$userQuery"');
    print('🔍 DEBUG: Available tools:');
    for (final tool in module.tools) {
      print(
          '🔍 DEBUG: - Tool: "${tool.toolName}" - Keywords: ${tool.keywords} - Prompt: ${tool.responsePrompt}');
    }
    return '''
    You are ${module.name}. ${module.prompt}

A user has sent the following message: "$userQuery"

Analyze the user's message and determine if it matches any of your available tools:

Available tools:
$toolsList

Instructions:
- Look for keywords that match tool purposes
- If the user asks about "popular items", "menu", "food", "drinks" → use "get_popular_items" if available
- If the user asks about hotel services, spa, gym → use "get_hotel_services"
- If the user asks about booking, rooms → use "book_room"
- If none match, use null for general conversation

Respond with ONLY this JSON format: {"tool_name": "exact_tool_name_or_null"}

Examples:
- "What are popular items?" → {"tool_name": "get_popular_items"}
- "Book a room" → {"tool_name": "book_room"}
- "Hello" → {"tool_name": null}
''';
  }

  /// Builds the prompt for Step 2 (Final Response) when a tool is used.
  String _buildFinalResponsePrompt(
    AiChatModule module,
    AiChatTool tool,
    String userQuery,
    dynamic toolResult,
  ) {
    return '''
    You are ${module.name}. ${module.prompt}
    The user said: "$userQuery"
    You have used your "${tool.toolName}" tool.
    Your goal for this tool is to: "${tool.responsePrompt}".
    ${toolResult != null ? 'The result of the tool execution is: ${jsonEncode(toolResult)}' : ''}
    Generate a friendly, conversational response that synthesizes this information for the user.
    ''';
  }

  /// Builds the prompt for a default conversation.
  String _buildDefaultPrompt(AiChatModule module, String userQuery) {
    return '''
    You are ${module.name}. ${module.prompt}
    The user said: "$userQuery"
    Engage in a friendly, helpful conversation.
    ''';
  }

  /// Finds a tool by its name in the module's tool list.
  AiChatTool? _findToolByName(AiChatModule module, String toolName) {
    try {
      return module.tools.firstWhere((tool) => tool.toolName == toolName);
    } catch (e) {
      return null; // Not found
    }
  }
}

/// --- Active Module Provider ---
/// This provider determines which AI persona is currently active.
/// You MUST integrate this with your settings feature where the user selects a role.
final activeAiModuleProvider = Provider<AiChatModule>((ref) {
  final settings = ref.watch(settingsControllerProvider);

  return settings.when(
    data: (data) {
      final selectedModule = data.aiChatModules
          .where((module) => module.id == data.selectedAiChatModuleId)
          .firstOrNull;

      return selectedModule ??
          (data.aiChatModules.isNotEmpty ? data.aiChatModules.first : null) ??
          const AiChatModule(
            id: 0,
            name: 'Assistant',
            description: '',
            prompt: 'You are a helpful assistant.',
            tools: [],
          );
    },
    error: (err, stack) => const AiChatModule(
      id: 0,
      name: 'Assistant',
      description: 'Default assistant',
      prompt: 'You are a helpful assistant.',
      tools: [],
    ),
    loading: () => const AiChatModule(
      id: 0,
      name: 'Assistant',
      description: 'Default assistant',
      prompt: 'You are a helpful assistant.',
      tools: [],
    ),
  );
});

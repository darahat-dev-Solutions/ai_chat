import 'package:ai_chat/core/api/api_service_provider.dart';
import 'package:ai_chat/features/ai_chat/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides and caches the list of popular items from the API
///
/// Widgets and other providers can watch this to get the data,
/// and it will automatically handle loading/error status and prevent
/// redundant API calls
final popularItemsProvider = FutureProvider<List<Item>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getPopularItems();
});

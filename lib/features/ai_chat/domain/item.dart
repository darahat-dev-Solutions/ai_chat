import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class ItemApiResponse with _$ItemApiResponse {
  const factory ItemApiResponse({
    required bool success,
    required List<Item> data,
    required String message,
    required int count,
  }) = _ItemApiResponse;

  factory ItemApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ItemApiResponseFromJson(json);
}

@freezed
class Item with _$Item {
  const factory Item({
    @JsonKey(name: 'item_id') int? id,
    @JsonKey(name: 'item_name') String? name,
    String? description,
    double? price,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

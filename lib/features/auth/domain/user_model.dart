import 'package:ai_chat/features/auth/domain/user_role.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Represents the metadata and the definitions of User
@JsonSerializable()
@HiveType(typeId: 2)
class UserModel {
  /// Id Definition
  @HiveField(0)
  final String uid;

  /// User Name Definition
  @HiveField(1)
  @JsonKey(name: 'name')
  final String? displayName;

  /// Email Definition
  @HiveField(2)
  final String? email;

  /// User Role Definition
  @HiveField(3)

  /// _parseUserRole turn the String from the json map
  /// and gives you back a UserRole object
  /// From JSON String-> _parseUserRole -> UserRole Object
  ///
  /// _userRoleToString turn the UserRole object into a simple
  /// String to build a Json Map
  /// UserRole Object -> _userRoleToString -> To Json String
  @JsonKey(fromJson: parseUserRole, toJson: _userRoleToString)
  final UserRole? role;

  /// User photoURL Definition
  @HiveField(4)
  @JsonKey(name: 'img_url')
  final String? photoURL;

  /// If any order created the User will be customer
  ///
  /// User customer id Definition
  @HiveField(5)
  @JsonKey(name: 'customer_id')
  final int? customerId;

  /// User Phone Definition
  @HiveField(6)
  final String? phone;

  /// UserModel Constructor
  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.customerId,
    this.phone,
    UserRole? role,
  }) : role = role ?? UserRole.guest;

  /// JSON factory (required for Freezed + json_serializable integration)
  ///
  /// Calls the generated function to create [UserModel] instance
  /// from a map

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Calls the generated function to convert the [UserModel] instance into a map
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// Set Role based on [roleString] value
UserRole parseUserRole(String? roleString) {
  switch (roleString) {
    case 'authenticatedUser':
      return UserRole.authenticatedUser;
    case 'admin':
      return UserRole.admin;
    case 'guest':
    default:
      return UserRole.guest;
  }
}

/// Convert User Role To String
String? _userRoleToString(UserRole? role) {
  return role?.roleName;
}

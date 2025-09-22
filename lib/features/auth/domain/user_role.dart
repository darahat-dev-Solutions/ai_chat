import 'package:hive/hive.dart';

part 'user_role.g.dart';

@HiveType(typeId: 6)

/// Represents the metadata and definition of a [UserRole]
class UserRole {
  @HiveField(0)

  /// Role Name Definition
  final String roleName;

  /// [UserRole] Constructor
  const UserRole(this.roleName);

  ///Assign UserRole Guest
  static const UserRole guest = UserRole('guest');

  ///Assign UserRole authenticatedUser
  static const UserRole authenticatedUser = UserRole('authenticatedUser');

  ///Assign userRole Admin
  static const UserRole admin = UserRole('admin');

  @override
  String toString() => 'UserRole.$roleName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRole &&
          runtimeType == other.runtimeType &&
          roleName == other.roleName);

  @override
  int get hashCode => roleName.hashCode;
}

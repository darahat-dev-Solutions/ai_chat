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

  /// Checks roleName is changed(used equatable here)
  List<Object?> get props => [roleName];

  /// Provides Readable String for debugging
  ///
  /// It give facility at checking print(UserRole.admin)
  /// show the actual string except show Instance of 'UserRole'
  @override
  String toString() => 'UserRole.$roleName';
}

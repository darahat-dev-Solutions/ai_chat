import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
/// its User model for authentication
class UserModel {
  /// first field for the hive/table is uid
  @HiveField(0)
  final String uid;

  /// second non required field
  @HiveField(1)
  final String? name;

  /// third required field for login
  @HiveField(2)
  final String email;

  /// its contstruct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  UserModel({required this.uid, required this.email, this.name});
}

library;

/// Base class for all custom exceptions in the application
///
/// All app-specific exceptions should extend this class

abstract class AppException implements Exception {
  /// Creates an [AppException]
  ///
  /// Requires [message] to describe the error
  /// [innerException] is option
  const AppException(this.message, [this.innerException]);
  @override
  String toString() =>
      innerException != null
          ? '$message (Inner exception: $innerException)'
          : message;

  /// A message describing the error
  final String message;

  /// The underlying exception that caused this error
  final Exception? innerException;
}

/// Thrown when there's an error communication with the server
/// Exception thrown when a server operation fails.
class ServerException implements Exception {
  /// Creates a [ServerException] with an error message.
  ServerException({required this.message});

  /// The error message describing what went wrong.
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when a cache operation fails.
/// Exception thrown when a server operation fails.
class CacheException implements Exception {
  /// Creates a [CacheException] with an error message.
  CacheException({required this.message});

  /// The error message describing what went wrong.
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when there's a network connectivity issue
class NetworkException extends AppException {
  /// Creates a [NetworkException]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception (if available)
  const NetworkException(super.message, [super.innerException]);
}

/// Thrown when there's an error in input validation
class ValidationException extends AppException {
  /// Creates a [ValidException]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception(if available
  const ValidationException(super.message, [super.innerException]);
}

/// Thrown when a requested resource is not found

class NotFoundException extends AppException {
  /// Creates a [NotFoundException ]
  ///
  /// [message] describes the network error
  /// [innerException] is the original exception(if available
  const NotFoundException(this.resourceType, this.identifier)
    : super('$resourceType with identifier $identifier not found');

  /// The type of resource that wasnt found
  final String resourceType;

  /// The identifier that wasnt found
  final String identifier;
}

/// Thrown when authentication fails

class AuthenticationException extends AppException {
  /// Creates a [AuthenticationException ]
  ///
  /// [message] describes the network error
  const AuthenticationException(super.message);
}

/// Thrown when a user doesnt have permission to perform an action
class PermissionException extends AppException {
  /// The permission that was denied
  const PermissionException(this.permission, String message) : super(message);

  /// The permission that was denied

  final String permission;
  @override
  String toString() => 'PermissionException for $permission: $message';
}

/// Custom Exceptions for out of box exception

class CustomException extends AppException {
  ///constructor calling only a variable message
  const CustomException(super.message, [super.innerException]);
}


/// How you will call these exception

// throw NetworkException('No internet connection');
// throw ValidationException('Invalid email address');
// throw AuthenticationException('Invalid credentials');
// throw PermissionException('admin', 'You do not have admin rights');
// throw NotFoundException('User', '1234');
// throw CacheException(message: 'Failed to read from cache');
// throw ServerException(message: 'Server error occurred');
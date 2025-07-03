import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Represents the severity level of a log message.
enum LogLevel {
  /// Debug messages for development.
  debug,

  /// Informational messages.
  info,

  /// Warning messages indicating potential issues.
  warning,

  /// Error messages indicating failure or critical issues.
  error,
}

/// A simple utility for logging messages during development.
///
/// Automatically includes an emoji based on log level.
/// Only logs in `kDebugMode`.
class AppLogger {
  static late Logger _logger;

  ///initialize the logger with appropriate configuration
  static void init() {
    _logger = Logger(
      printer:
          kDebugMode
              ? PrettyPrinter(dateTimeFormat: DateTimeFormat.dateAndTime)
              : SimplePrinter(), // Productionl: simple, less verbose
      level: kDebugMode ? Level.debug : Level.info,
    );
  }

  /// Log debug message(only in debug mode)
  static void debug(String message) {
    if (kDebugMode) {
      log(message, level: LogLevel.debug);
      _logger.d(message);
      developer.log(message, name: 'OpsMate');
    }
  }

  /// Log info messages
  static void info(String message) {
    if (kDebugMode) {
      log(message);
      _logger.i(message);
      developer.log(message, name: 'OpsMate', level: 800);
    }
  }

  /// Log warning messages
  static void warning(String message) {
    if (kDebugMode) {
      log(message, level: LogLevel.warning);
      _logger.w(message);
      developer.log(message, name: 'OpsMate', level: 900);
    }
  }

  /// lOG ERROR messages with option error object and stack trace
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      log(message, level: LogLevel.error);
      _logger.e(message, error: error, stackTrace: stackTrace);

      developer.log(
        message,
        name: 'OpsMate',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Represents the severity level of a log message.

  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final emoji =
          {
            // debug message if in debug mode
            LogLevel.debug: '🐛',

            /// Informational messages.
            LogLevel.info: 'ℹ️',

            /// Warning messages indicating potential issues.
            LogLevel.warning: '⚠️',

            /// Error messages indicating failure or critical issues.
            LogLevel.error: '❌',
          }[level];
      print('$emoji $message');
    }
  }
}

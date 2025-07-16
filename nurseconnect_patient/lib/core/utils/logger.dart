// lib/core/utils/logger.dart
import 'package:flutter/foundation.dart'; // For kDebugMode

class AppLogger {
  static void log(String message, {String tag = 'App'}) {
    if (kDebugMode) {
      // Only log in debug mode
      print('[$tag] $message');
    }
  }

  static void error(String message, {String tag = 'App', dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('[$tag] ERROR: $message');
      if (error != null) {
        print('[$tag] Error Details: $error');
      }
      if (stackTrace != null) {
        print('[$tag] Stack Trace: $stackTrace');
      }
    }
  }

  // Add more logging levels if needed (e.g., warn, info, debug)
}
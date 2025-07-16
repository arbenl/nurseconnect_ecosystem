// lib/core/utils/app_logger.dart
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String tag = 'App'}) {
    if (kDebugMode) {
      debugPrint('[$tag] $message');
    }
  }
}
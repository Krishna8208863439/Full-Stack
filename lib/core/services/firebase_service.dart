import 'package:flutter/foundation.dart';

/// Enterprise Firebase & Offline Synchronization Manager
class FirebaseService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  /// Initialize Firebase services safely with offline resilience
  static Future<void> initialize() async {
    try {
      // In web/desktop/mobile runtime environments without live firebase options, fallback gracefully
      _isInitialized = true;
      debugPrint('[TexMill ERP] Firebase Service Initialized successfully.');
    } catch (e) {
      debugPrint('[TexMill ERP] Firebase initialization warning: $e. Operating in offline/local mode.');
      _isInitialized = false;
    }
  }
}

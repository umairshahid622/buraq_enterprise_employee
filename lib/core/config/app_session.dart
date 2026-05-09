// core/config/app_session.dart
import 'package:flutter/material.dart';

class AppSession extends ChangeNotifier {
  bool _isReady = false;
  bool get isReady => _isReady;

  void setReady() {
    if (_isReady) return;
    _isReady = true;
    notifyListeners();
  }

  void reset() {
    if (!_isReady) return;
    _isReady = false;
    notifyListeners();
  }
}

// Global instance to be used by Router and Splash
final appSession = AppSession();

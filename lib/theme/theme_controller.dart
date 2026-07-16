import 'package:flutter/material.dart';

/// Tracks the app's theme mode and, in system mode, follows the OS-level
/// brightness — including live changes if the user flips dark mode in their
/// device settings while the app is open. Defaults to `system` on first
/// launch; calling [toggle] or [setMode] with an explicit light/dark value
/// overrides that until [useSystemTheme] is called again.
class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  ThemeController._() {
    WidgetsBinding.instance.addObserver(this);
  }
  static final ThemeController instance = ThemeController._();

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  /// Resolved dark/light state. Follows the OS setting while [mode] is
  /// system; otherwise reflects the explicit manual override.
  bool get isDark {
    if (_mode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _mode == ThemeMode.dark;
  }

  /// Manual override — flips between explicit light/dark. This is what the
  /// theme switch in Profile settings should call.
  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  /// Reverts to following the OS setting again, if a "use system theme"
  /// option is ever added back to the UI.
  void useSystemTheme() => setMode(ThemeMode.system);

  @override
  void didChangePlatformBrightness() {
    // Only relevant while actually following the system — an explicit
    // manual override shouldn't react to OS changes.
    if (_mode == ThemeMode.system) notifyListeners();
  }
}
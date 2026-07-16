import 'package:flutter/material.dart';
import 'theme_controller.dart';

class AppTheme {

  static bool get _dark => ThemeController.instance.isDark;

  static Color get primary => _dark ? _Dark.primary : _Light.primary;
  static Color get primarySoft => _dark ? _Dark.primarySoft : _Light.primarySoft;
  static Color get accent => _dark ? _Dark.primarySoft : _Light.primarySoft;
  static Color get background => _dark ? _Dark.background : _Light.background;
  static Color get surface => _dark ? _Dark.surface : _Light.surface;
  static Color get muted => _dark ? _Dark.muted : _Light.muted;
  static Color get textPrimary => _dark ? _Dark.textPrimary : _Light.textPrimary;
  static Color get textSecondary => _dark ? _Dark.textSecondary : _Light.textSecondary;
  static Color get danger => _dark ? _Dark.danger : _Light.danger;
  static Color get warning => _dark ? _Dark.warning : _Light.warning;
  static Color get info => _dark ? _Dark.info : _Light.info;

  static Color get pasteGreen => _dark ? _Dark.pasteGreen : _Light.pasteGreen;
  static Color get pastelBlue => _dark ? _Dark.pastelBlue : _Light.pastelBlue;
  static Color get pastelOrange => _dark ? _Dark.pastelOrange : _Light.pastelOrange;
  static Color get pastelPurple => _dark ? _Dark.pastelPurple : _Light.pastelPurple;

  // Spacing/radius are not brightness-dependent — stay as real constants.
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing10 = 10;
  static const double spacing12 = 12;
  static const double spacing14 = 14;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius24 = 24;

  static List<BoxShadow> get cardShadow => _dark
      ? const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ]
      : const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ];

  static List<BoxShadow> get thinShadow => _dark
      ? const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ]
      : const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ];

  // ---------------------------------------------------------------------
  // ThemeData builders. These are called ONCE each and handed to
  // MaterialApp(theme: ..., darkTheme: ...) — themeMode decides which one
  // is active, so each builder must use its OWN fixed palette, not the
  // getters above (which are dynamic and would create a circular/incorrect
  // dependency here).
  // ---------------------------------------------------------------------

  static ThemeData lightTheme() => _buildTheme(
        brightness: Brightness.light,
        background: _Light.background,
        surface: _Light.surface,
        primary: _Light.primary,
        primarySoft: _Light.primarySoft,
        textPrimary: _Light.textPrimary,
        textSecondary: _Light.textSecondary,
        muted: _Light.muted,
        danger: _Light.danger,
      );

  static ThemeData darkTheme() => _buildTheme(
        brightness: Brightness.dark,
        background: _Dark.background,
        surface: _Dark.surface,
        primary: _Dark.primary,
        primarySoft: _Dark.primarySoft,
        textPrimary: _Dark.textPrimary,
        textSecondary: _Dark.textSecondary,
        muted: _Dark.muted,
        danger: _Dark.danger,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color primarySoft,
    required Color textPrimary,
    required Color textSecondary,
    required Color muted,
    required Color danger,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'Inter',
      colorScheme: colorScheme.copyWith(
        surface: surface,
        primary: primary,
        secondary: primarySoft,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primarySoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius20),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius20),
          borderSide: BorderSide(color: danger, width: 1.2),
        ),
      ),
      textTheme: TextTheme(
        displaySmall: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.05,
        ),
        headlineSmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.1,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: muted,
          letterSpacing: 0.2,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.6,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Fixed light-mode palette — source of truth for both AppTheme's getters
/// and lightTheme().
class _Light {
  static const Color primary = Color(0xFF0F9D58);
  static const Color primarySoft = Color(0xFFE8F5E9);
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF8A8F98);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color danger = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF2196F3);
  static const Color pasteGreen = Color(0xFFE8F5E9);
  static const Color pastelBlue = Color(0xFFE3F2FD);
  static const Color pastelOrange = Color(0xFFFFE0B2);
  static const Color pastelPurple = Color(0xFFF3E5F5);
}

/// Fixed dark-mode palette — source of truth for both AppTheme's getters
/// and darkTheme(). Kept intentionally close in hue to light mode (same
/// green primary) so the brand still reads as "Ajo Hub" in either mode.
class _Dark {
  static const Color primary = Color(0xFF2FBE75); // brighter for contrast on dark bg
  static const Color primarySoft = Color(0xFF1B2E22);
  static const Color background = Color(0xFF121417);
  static const Color surface = Color(0xFF1C1F24);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFB0B4BB);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF60A5FA);
  static const Color pasteGreen = Color(0xFF1B2E22);
  static const Color pastelBlue = Color(0xFF1A2733);
  static const Color pastelOrange = Color(0xFF332512);
  static const Color pastelPurple = Color(0xFF2B1F33);
}
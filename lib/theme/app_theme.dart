import 'package:flutter/material.dart';

/// Centralised dark-gothic theme for the Crimson Eclipse Tileset Generator.
class AppTheme {
  AppTheme._();

  // ── Palette ─────────────────────────────────────────────────────────────

  static const Color _scaffoldBg = Color(0xFF1A1A2E);
  static const Color _primaryCrimson = Color(0xFF8B0000);
  static const Color _secondaryCrimson = Color(0xFFE94560);
  static const Color _surface = Color(0xFF16213E);
  static const Color _card = Color(0xFF0F3460);
  static const Color _textPrimary = Color(0xFFE0E0E0);
  static const Color _textSecondary = Color(0xFFB0B0B0);
  static const Color _inputBorder = Color(0xFF8B0000);

  // ── Theme ───────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _scaffoldBg,
      primaryColor: _primaryCrimson,
      colorScheme: const ColorScheme.dark(
        primary: _primaryCrimson,
        secondary: _secondaryCrimson,
        surface: _surface,
        error: Color(0xFFCF6679),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textPrimary,
        onError: Colors.black,
      ),
      cardColor: _card,
      canvasColor: _surface,
      dividerColor: _primaryCrimson.withAlpha(80),
      fontFamily: 'monospace',

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: _textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _secondaryCrimson,
          letterSpacing: 1.2,
        ),
      ),

      // ── Text ────────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        displayMedium: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        displaySmall: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        headlineLarge: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        headlineMedium: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        headlineSmall: TextStyle(
          color: _secondaryCrimson,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        titleMedium: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        titleSmall: TextStyle(color: _textSecondary, fontFamily: 'monospace'),
        bodyLarge: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        bodyMedium: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        bodySmall: TextStyle(color: _textSecondary, fontFamily: 'monospace'),
        labelLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        labelSmall: TextStyle(color: _textSecondary, fontFamily: 'monospace'),
      ),

      // ── ElevatedButton ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _primaryCrimson,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // ── InputDecoration ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        labelStyle: const TextStyle(color: _textSecondary, fontFamily: 'monospace'),
        hintStyle: TextStyle(color: _textSecondary.withAlpha(120), fontFamily: 'monospace'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _inputBorder.withAlpha(120)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _secondaryCrimson, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),

      // ── DropdownMenu ────────────────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: _textPrimary, fontFamily: 'monospace'),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _inputBorder),
          ),
        ),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: _card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _primaryCrimson.withAlpha(60)),
        ),
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: _surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _primaryCrimson),
        ),
        titleTextStyle: const TextStyle(
          color: _secondaryCrimson,
          fontFamily: 'monospace',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ── Icon ────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: _secondaryCrimson),

      // ── Scrollbar ───────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(_primaryCrimson.withAlpha(160)),
        radius: const Radius.circular(4),
      ),

      // ── Progress Indicator ──────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _secondaryCrimson,
        linearTrackColor: _surface,
      ),

      // ── Switch / Toggle ─────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _secondaryCrimson;
          return _textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryCrimson.withAlpha(120);
          }
          return _surface;
        }),
      ),

      // ── SegmentedButton ─────────────────────────────────────────────────
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _primaryCrimson;
            return _surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return _textSecondary;
          }),
          side: WidgetStateProperty.all(
            BorderSide(color: _primaryCrimson.withAlpha(120)),
          ),
        ),
      ),
    );
  }
}

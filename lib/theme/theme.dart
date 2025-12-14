import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// LIGHT MODE COLORS
// ============================================================================
const Color primaryMainLight = Color(0xFF0F172A);    // Slate 900
const Color primaryLightLight = Color(0xFFF1F5F9);   // Slate 100
const Color primaryDarkLight = Color(0xFF020617);    // Slate 950

// ============================================================================
// DARK MODE COLORS
// ============================================================================
const Color primaryMainDark = Color(0xFF38BDF8);     // Sky 400
const Color primaryLightDark = Color(0xFF0F172A);    // Slate 900
const Color primaryDarkDark = Color(0xFF7DD3FC);     // Sky 300

// ============================================================================
// SEMANTIC COLORS
// ============================================================================
const Color secondaryColor = Color(0xFF0EA5E9);      // Sky 500
const Color successMain = Color(0xFF10B981);         // Green 500
const Color errorMain = Color(0xFFEF4444);           // Red 500
const Color warningMain = Color(0xFFF59E0B);         // Amber 500
const Color infoMain = Color(0xFF3B82F6);            // Blue 500

// ============================================================================
// MAIN PALETTE - Corporate Premium (Deep Slate & Vibrant Blue)
// ============================================================================
const Color primaryMain = Color(0xFF0F172A);         // Slate 900
const Color primaryAccent = Color(0xFF38BDF8);       // Sky 400
const Color secondaryMain = Color(0xFF64748B);       // Slate 500
const Color backgroundLight = Color(0xFFF8FAFC);     // Slate 50
const Color surfaceLight = Colors.white;
const Color errorColor = Color(0xFFEF4444);          // Red 500

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base, bool isDark) {
    final color = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);

    return GoogleFonts.interTextTheme(base).copyWith(
      // h1
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.2,
        color: color,
      ),
      // h2
      displayMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.32,
        height: 1.3,
        color: color,
      ),
      // h3
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.28,
        height: 1.3,
        color: color,
      ),
      // h4
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      ),
      // h5
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      ),
      // h6
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      ),
      // subtitle1
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      ),
      // subtitle2
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.57,
        color: color,
      ),
      // body1
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: color,
      ),
      // body2
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.57,
        color: color,
      ),
      // button
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50

    colorScheme: ColorScheme.light(
      primary: primaryMainLight,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF1E293B), // Slate 800
      background: const Color(0xFFF8FAFC), // Slate 50
      error: errorMain,
      onError: Colors.white,
    ),

    textTheme: _buildTextTheme(Typography.englishLike2018, false),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryMainLight, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorMain),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorMain, width: 1),
      ),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      floatingLabelStyle: const TextStyle(color: primaryMainLight),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryMainLight,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryMainLight,
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryMainLight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryMainLight,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryMainLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide.none,
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: Color(0xFF64748B),
      textColor: Color(0xFF1E293B),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900

    colorScheme: ColorScheme.dark(
      primary: primaryMainDark,
      onPrimary: const Color(0xFF0F172A),
      secondary: secondaryColor,
      onSecondary: Colors.white,
      surface: const Color(0xFF1E293B), // Slate 800
      onSurface: const Color(0xFFF8FAFC), // Slate 50
      background: const Color(0xFF0F172A), // Slate 900
      error: errorMain,
      onError: Colors.white,
    ),

    textTheme: _buildTextTheme(Typography.englishLike2018, true),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E293B),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Color(0xFFF8FAFC)),
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFFF8FAFC),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      shape: const Border(
        bottom: BorderSide(color: Color(0xFF334155), width: 1),
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      shadowColor: Colors.black.withOpacity(0.4),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryMainDark, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorMain),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorMain, width: 1),
      ),
      labelStyle: const TextStyle(color: Color(0xFF64748B)),
      floatingLabelStyle: const TextStyle(color: primaryMainDark),
      hintStyle: const TextStyle(color: Color(0xFF64748B)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryMainDark,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shadowColor: Colors.transparent,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryMainDark,
        side: const BorderSide(color: Color(0xFF334155)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ).copyWith(
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.05)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryMainDark,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryMainDark,
      foregroundColor: Color(0xFF0F172A),
      elevation: 4,
      shape: CircleBorder(),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withOpacity(0.05),
      side: BorderSide.none,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFF8FAFC),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide.none,
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFF8FAFC),
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: Color(0xFF94A3B8),
      textColor: Color(0xFFF8FAFC),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
  );
}

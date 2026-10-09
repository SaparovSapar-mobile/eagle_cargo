import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/providers/theme_provider.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Compatibility helpers for ybexpress & kamil_cargo
  bool isDark() => watch<ThemeProvider>().themeMode == ThemeMode.dark;
  bool isDarkRead() => read<ThemeProvider>().themeMode == ThemeMode.dark;

  Color textColor() => isDark() ? Colors.white : Colors.black87;

  List<BoxShadow> defaultShadow() => isDark()
      ? []
      : [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];

  // Add more common theme helpers if needed
}

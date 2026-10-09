import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/providers/translation_provider.dart';

extension TranslateExtension on BuildContext {
  /// translation (rebuilds when provider updates)
  String t(String key) {
    return watch<TranslationProvider>().t(key);
  }

  /// translation (no rebuild, useful for static labels or inside builders)
  String tr(String key) {
    return read<TranslationProvider>().t(key);
  }

  /// current language code: "tk", "ru", "en" or one of the firm's own
  String get langCode => read<TranslationProvider>().langCode;

  TranslationProvider get translationProvider => read<TranslationProvider>();
}

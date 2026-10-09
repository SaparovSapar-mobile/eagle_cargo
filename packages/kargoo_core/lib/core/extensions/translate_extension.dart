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

  AppLanguage get currentLang => read<TranslationProvider>().currentLang;

  /// get current language code: "tk", "ru", "en"
  String get langCode => read<TranslationProvider>().currentLang.code;

  TranslationProvider get translationProvider => read<TranslationProvider>();
}

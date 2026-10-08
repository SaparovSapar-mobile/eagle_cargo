import 'package:flutter/material.dart';
import 'package:kargoo_core/kargoo_core.dart'
    hide Palette, PreferenceManager, PreferenceKeys;

/// Fallback labels for keys the translation backend does not serve yet.
///
/// [LocalTranslateExtension.tl] always prefers the server value, so once these
/// keys are added in the web panel the fallbacks stop being used.
const Map<String, Map<String, String>> _localTranslations = {
  'mb_foreign_warehouses': {
    'tk': 'Daşary ýurt ammarlary',
    'ru': 'Зарубежные склады',
    'en': 'Foreign warehouses',
  },
  'mb_warnings': {
    'tk': 'Duýduryşlar',
    'ru': 'Предупреждения',
    'en': 'Warnings',
  },
  'mb_warning_accept': {
    'tk': 'Kabul edýärin',
    'ru': 'Принимаю',
    'en': 'I accept',
  },
  'mb_warning_must_accept': {
    'tk': 'Dowam etmek üçin kabul ediň',
    'ru': 'Чтобы продолжить, нажмите «Принимаю»',
    'en': 'Please accept to continue',
  },
};

extension LocalTranslateExtension on BuildContext {
  /// Translation with a bundled fallback (rebuilds when the language changes).
  String tl(String key) => _withFallback(key, t(key));

  /// Translation with a bundled fallback, without subscribing to rebuilds.
  String tlr(String key) => _withFallback(key, tr(key));

  String _withFallback(String key, String translated) {
    // TranslationProvider echoes the key back when it has no entry for it.
    if (translated != key) return translated;
    return _localTranslations[key]?[langCode] ?? key;
  }
}

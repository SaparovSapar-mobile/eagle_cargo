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
    'tk': 'Duýduryşlar / Maglumat',
    'ru': 'Предупреждения / Информация',
    'en': 'Warnings / Info',
  },
  'mb_warning_accept': {
    'tk': 'Kabul edýärin',
    'ru': 'Принимаю',
    'en': 'I accept',
  },
  'mb_warning_read_to_end': {
    'tk': 'Kabul etmek üçin ahyryna çenli okaň',
    'ru': 'Прочитайте до конца, чтобы принять',
    'en': 'Read to the end to accept',
  },
  // `{n}` and `{total}` are substituted by the caller.
  'mb_warning_counter': {
    'tk': '{n} / {total}',
    'ru': '{n} из {total}',
    'en': '{n} of {total}',
  },
  'mb_warnings_rules': {
    'tk': 'Düzgünler we şertler',
    'ru': 'Правила и условия',
    'en': 'Rules and terms',
  },
  'mb_warnings_info': {
    'tk': 'Maglumat',
    'ru': 'Информация',
    'en': 'Information',
  },
  'mb_warning_accepted': {
    'tk': 'Kabul edildi',
    'ru': 'Принято',
    'en': 'Accepted',
  },
  'mb_nothing_yet': {
    'tk': 'Häzirlikçe hiç zat ýok',
    'ru': 'Пока ничего нет',
    'en': 'Nothing here yet',
  },
  'mb_retry': {
    'tk': 'Gaýtadan synanyşmak',
    'ru': 'Повторить',
    'en': 'Retry',
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

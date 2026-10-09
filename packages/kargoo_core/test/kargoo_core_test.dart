import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kargoo_core/kargoo_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _uz = LanguageModel(
  code: 'uz',
  name: 'Oʻzbekcha',
  flag: '🇺🇿',
  fallback: 'ru',
);
const _fa = LanguageModel(code: 'fa', name: 'فارسی', fallback: 'en');

TranslationModel _item(String key, Map<String, String> values) =>
    TranslationModel(key: key, category: 'mobile_app', values: values);

Future<void> _initPrefs([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  await PreferenceManager.init();
}

void main() {
  group('TranslationModel', () {
    test('keeps every language field, whatever the code', () {
      final item = TranslationModel.fromJson({
        'key': 'profile_title',
        'category': 'mobile_app',
        'tk': 'Profil',
        'ru': 'Профиль',
        'en': 'Profile',
        'uz': 'Profil',
        'ko': '프로필',
      });

      expect(item.key, 'profile_title');
      expect(item.category, 'mobile_app');
      expect(item.values.keys, unorderedEquals(['tk', 'ru', 'en', 'uz', 'ko']));
      expect(item.get('ko'), '프로필');
      expect(item.values.containsKey('key'), isFalse);
    });

    test('round-trips through the cache format', () {
      final json = {
        'key': 'dark_mode',
        'category': 'mobile_app',
        'ru': 'Тёмная тема',
        'uz': 'Тёмная тема',
      };
      expect(TranslationModel.fromJson(json).toJson(), json);
    });

    test('treats an empty string as missing', () {
      final item = _item('k', {'ru': ''});
      expect(item.get('ru'), isNull);
    });
  });

  group('TranslationProvider.t', () {
    late TranslationProvider provider;

    setUp(() async {
      await _initPrefs();
      provider = TranslationProvider()
        ..setLanguages([...LanguageModel.base, _uz]);
    });

    test('uses the selected firm language', () {
      provider
        ..setTranslations([
          _item('profile_title', {'tk': 'Profil', 'ru': 'Профиль', 'uz': 'Profil UZ'}),
        ])
        ..setLanguage('uz');
      expect(provider.t('profile_title'), 'Profil UZ');
    });

    test('falls back to the language fallback, then tk, then the key', () {
      provider
        ..setTranslations([
          _item('only_ru', {'tk': 'TK', 'ru': 'RU'}),
          _item('only_tk', {'tk': 'TK'}),
        ])
        ..setLanguage('uz');

      expect(provider.t('only_ru'), 'RU');
      expect(provider.t('only_tk'), 'TK');
      expect(provider.t('missing'), 'missing');
    });

    test('first item wins when a key repeats across categories', () {
      provider.setTranslations([
        _item('dup', {'en': 'first'}),
        _item('dup', {'en': 'second'}),
      ]);
      expect(provider.t('dup'), 'first');
    });
  });

  group('TranslationProvider languages', () {
    test('a disabled language moves to its fallback and is saved', () async {
      await _initPrefs();
      final provider = TranslationProvider()
        ..setLanguages([...LanguageModel.base, _uz])
        ..setLanguage('uz');

      provider.setLanguages(LanguageModel.base);

      expect(provider.langCode, 'ru');
      expect(PreferenceManager.instance.getStringValue('APP_LANGUAGE'), 'ru');
    });

    test('without a known fallback it moves to the default language', () async {
      await _initPrefs();
      final provider = TranslationProvider()..setLanguage('de');

      provider.setLanguages(LanguageModel.base);

      expect(provider.langCode, TranslationProvider.defaultLanguage);
    });

    test('an available language is kept', () async {
      await _initPrefs();
      final provider = TranslationProvider()
        ..setLanguages([...LanguageModel.base, _uz])
        ..setLanguage('uz');

      provider.setLanguages([...LanguageModel.base, _uz, _fa]);

      expect(provider.langCode, 'uz');
      expect(provider.languages.map((e) => e.code), ['tk', 'ru', 'en', 'uz', 'fa']);
    });

    test('fa, ar and ur are right to left', () async {
      await _initPrefs();
      final provider = TranslationProvider();
      for (final code in ['fa', 'ar', 'ur']) {
        provider.setLanguage(code);
        expect(provider.isRtl, isTrue, reason: code);
      }
      for (final code in ['tk', 'ru', 'en', 'uz', 'zh']) {
        provider.setLanguage(code);
        expect(provider.isRtl, isFalse, reason: code);
      }
    });

    test('initialize restores the saved language and both caches offline', () async {
      await _initPrefs({
        'APP_LANGUAGE': 'uz',
        'LANGUAGES_CACHE': jsonEncode(
          [...LanguageModel.base, _uz].map((e) => e.toJson()).toList(),
        ),
        'TRANSLATIONS_CACHE': jsonEncode([
          {'key': 'hello', 'category': 'mobile_app', 'ru': 'Привет', 'uz': 'Salom'},
        ]),
      });
      final provider = TranslationProvider();

      // Connectivity is unavailable under the test binding, so this only
      // exercises the cache path.
      await provider.initialize(host: 'http://localhost', path: '/x').catchError((_) {});

      expect(provider.langCode, 'uz');
      expect(provider.languages.last.code, 'uz');
      expect(provider.t('hello'), 'Salom');
    });
  });
}

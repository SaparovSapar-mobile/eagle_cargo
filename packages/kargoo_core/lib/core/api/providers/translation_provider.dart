import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../preferences/preference_keys.dart';
import '../../preferences/preferences_util.dart';
import '../models/language_model.dart';
import '../models/translation_model.dart';
import '../services/translation_service.dart';
import '../../utils/material_languages.dart';

/// Kept for apps that still import it; languages are plain codes now, since a
/// firm can add its own on top of these three.
@Deprecated('Use language codes with TranslationProvider.setLanguageCode')
enum AppLanguage { tm, ru, en }

@Deprecated('Use language codes with TranslationProvider.setLanguageCode')
extension AppLanguageExt on AppLanguage {
  String get code => switch (this) {
    AppLanguage.tm => "tk",
    AppLanguage.ru => "ru",
    AppLanguage.en => "en",
  };
}

class TranslationProvider extends ChangeNotifier {
  /// Used when nothing is saved yet, or the saved language is gone.
  static const String defaultLanguage = "en";

  /// Languages written right to left — the only per-language knowledge the
  /// app keeps; everything else comes from the languages endpoint.
  static const Set<String> rtlLanguages = {"fa", "ar", "ur"};

  final PreferenceManager _cache = PreferenceManager.instance;

  String _langCode = defaultLanguage;

  /// Selected language code: "tk", "ru", "en" or one of the firm's own.
  String get currentCode => _langCode;

  List<LanguageModel> _languages = LanguageModel.base;

  /// Languages to pick from, in the order the server sent them.
  List<LanguageModel> get languages => List.unmodifiable(_languages);

  List<TranslationModel> _translations = [];
  List<TranslationModel> get translations => List.unmodifiable(_translations);

  /// First item per key, in category order — [t] is called on every build.
  Map<String, TranslationModel> _byKey = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LanguageModel? get currentLanguage => _find(_languages, _langCode);

  bool get isRtl => rtlLanguages.contains(_langCode);

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  /// Locale for the built-in widgets (date picker, system dialogs) only.
  ///
  /// Flutter has no Material strings for some codes (`tk`, `tg`, ...); those
  /// use the language's fallback, then [defaultLanguage], so the widgets never
  /// break. The texts themselves still come from [t].
  Locale get materialLocale {
    for (final code in [_langCode, fallbackOf(_langCode), defaultLanguage]) {
      if (code != null && kMaterialSupportedLanguageCodes.contains(code)) {
        return Locale(code);
      }
    }
    return const Locale(defaultLanguage);
  }

  /// Base language standing in for [code] where it has no text.
  String? fallbackOf(String code) => _find(_languages, code)?.fallback;

  Future<bool> _hasInternet() async {
    final List<ConnectivityResult> result = await Connectivity()
        .checkConnectivity();
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      return false;
    }
    return true;
  }

  /// Shows the cached texts right away and refreshes them from the server.
  ///
  /// With a cache the refresh runs in the background, so the app does not
  /// wait for the network; on the very first launch it is awaited instead.
  /// Pass [languagesPath] and [firmGuid] to get the firm's own languages.
  Future<void> initialize({
    required String host,
    required String path,
    String? languagesPath,
    String? firmGuid,
  }) async {
    final savedLang = _cache.getStringValue(PreferenceKeys.appLanguage);
    if (savedLang.isNotEmpty) _langCode = savedLang;

    _loadLanguagesFromCache();
    final cachedLoaded = await loadFromCache();
    notifyListeners();

    if (!await _hasInternet()) return;

    final refresh = Future.wait([
      loadAllTranslations(
        host: host,
        path: path,
        firmGuid: firmGuid,
        forceRefresh: true,
      ),
      if (languagesPath != null && firmGuid != null)
        loadLanguages(host: host, path: languagesPath, firmGuid: firmGuid),
    ]);
    if (!cachedLoaded) await refresh;
  }

  void setLanguageCode(String code) {
    if (code == _langCode) return;
    _langCode = code;
    _cache.setStringValue(PreferenceKeys.appLanguage, code);
    notifyListeners();
  }

  // -----------------------------
  // LANGUAGES
  // -----------------------------

  void _loadLanguagesFromCache() {
    final json = _cache.getStringValue(PreferenceKeys.languagesCache);
    if (json.isEmpty) return;
    try {
      final list = (jsonDecode(json) as List<dynamic>)
          .map((e) => LanguageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) _languages = list;
    } catch (e) {
      debugPrint("Broken languages cache: $e");
    }
  }

  /// Network or server errors keep the current (cached) list.
  Future<void> loadLanguages({
    required String host,
    required String path,
    required String firmGuid,
  }) async {
    try {
      final list = await TranslationService.getLanguages(
        host: host,
        path: path,
        firmGuid: firmGuid,
      );
      if (list.isEmpty) return;
      setLanguages(list);
      _cache.setStringValue(
        PreferenceKeys.languagesCache,
        jsonEncode(list.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint("Failed to load languages: $e");
    }
  }

  /// Replaces the list and, when the firm disabled the selected language,
  /// silently moves to its fallback (known from the previous list) or to
  /// [defaultLanguage].
  @visibleForTesting
  void setLanguages(List<LanguageModel> list) {
    final previous = _languages;
    _languages = list;

    if (_find(list, _langCode) == null) {
      final fallback = _find(previous, _langCode)?.fallback;
      final next = fallback != null && _find(list, fallback) != null
          ? fallback
          : _find(list, defaultLanguage) != null
          ? defaultLanguage
          : list.first.code;
      _langCode = next;
      _cache.setStringValue(PreferenceKeys.appLanguage, next);
    }
    notifyListeners();
  }

  static LanguageModel? _find(List<LanguageModel> list, String code) {
    for (final language in list) {
      if (language.code == code) return language;
    }
    return null;
  }

  // -----------------------------
  // TEXTS
  // -----------------------------

  Future<bool> loadFromCache() async {
    final json = _cache.getStringValue(PreferenceKeys.translationsCache);
    if (json.isEmpty) return false;

    try {
      final list = jsonDecode(json) as List<dynamic>;
      setTranslations(
        list
            .map((e) => TranslationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      return _translations.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveToCache() async {
    final jsonData = jsonEncode(_translations.map((e) => e.toJson()).toList());
    _cache.setStringValue(PreferenceKeys.translationsCache, jsonData);
  }

  Future<void> loadAllTranslations({
    required String host,
    required String path,
    String? firmGuid,
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;
    if (!forceRefresh && _translations.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final categories = [
        "customer_dashboard",
        "firm_panel",
        "admin_panel",
        "globals",
        "others",
        "mobile_app",
      ];

      final results = await Future.wait(
        categories.map(
          (c) => _loadCategory(
            host: host,
            path: path,
            category: c,
            firmGuid: firmGuid,
          ),
        ),
      );

      // The current texts stay on screen until the new ones are complete.
      final merged = results.expand((e) => e).toList();
      if (merged.isNotEmpty) {
        setTranslations(merged);
        await _saveToCache();
      }
    } catch (e) {
      debugPrint("Failed to load translations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<TranslationModel>> _loadCategory({
    required String host,
    required String path,
    required String category,
    String? firmGuid,
  }) async {
    try {
      return await TranslationService.getTranslations(
        host: host,
        path: path,
        category: category,
        firmGuid: firmGuid,
      );
    } catch (e) {
      debugPrint("Failed category $category: $e");
      return [];
    }
  }

  @visibleForTesting
  void setTranslations(List<TranslationModel> list) {
    _translations = list;
    _byKey = {};
    for (final item in list) {
      final key = item.key;
      if (key != null) _byKey.putIfAbsent(key, () => item);
    }
  }

  /// Selected language → its fallback → `tk` → the key itself.
  ///
  /// The server already fills firm languages from their fallback; the chain
  /// covers an old cache or a key added since.
  String t(String key) {
    final item = _byKey[key];
    if (item == null) return key;

    final fallback = fallbackOf(_langCode);
    return item.get(_langCode) ??
        (fallback != null ? item.get(fallback) : null) ??
        item.get("tk") ??
        key;
  }
}

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../preferences/preference_keys.dart';
import '../../preferences/preferences_util.dart';
import '../models/translation_model.dart';
import '../services/translation_service.dart';

enum AppLanguage { tm, ru, en }

extension AppLanguageExt on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.tm:
        return "tk";
      case AppLanguage.ru:
        return "ru";
      case AppLanguage.en:
        return "en";
    }
  }
}

class TranslationProvider extends ChangeNotifier {
  final PreferenceManager _cache = PreferenceManager.instance;

  AppLanguage _currentLang = AppLanguage.en;
  AppLanguage get currentLang => _currentLang;

  final List<TranslationModel> _translations = [];
  List<TranslationModel> get translations => _translations;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> _hasInternet() async {
    final List<ConnectivityResult> result = await Connectivity()
        .checkConnectivity();
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> initialize({required String host, required String path}) async {
    String savedLang = _cache.getStringValue(PreferenceKeys.appLanguage);
    if (savedLang.isNotEmpty) {
      _currentLang = AppLanguage.values.firstWhere(
        (e) => e.code == savedLang,
        orElse: () => AppLanguage.en,
      );
    }

    bool cachedLoaded = await loadFromCache();
    if (cachedLoaded) {
      notifyListeners();
    }

    final hasInternet = await _hasInternet();
    if (hasInternet) {
      await loadAllTranslations(host: host, path: path, forceRefresh: true);
    }
  }

  void setLanguage(AppLanguage lang) {
    if (lang == _currentLang) return;
    _currentLang = lang;
    _cache.setStringValue(PreferenceKeys.appLanguage, lang.code);
    notifyListeners();
  }

  Future<bool> loadFromCache() async {
    final json = _cache.getStringValue(PreferenceKeys.translationsCache);
    if (json.isEmpty) return false;

    try {
      final list = jsonDecode(json) as List<dynamic>;
      _translations.clear();
      _translations.addAll(
        list.map((e) => TranslationModel.fromJson(e as Map<String, dynamic>)),
      );
      return true;
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
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;
    if (!forceRefresh && _translations.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _translations.clear();
      final categories = [
        "customer_dashboard",
        "firm_panel",
        "admin_panel",
        "globals",
        "others",
        "mobile_app",
      ];

      await Future.wait(
        categories.map(
          (c) => loadCategory(host: host, path: path, category: c),
        ),
      );

      if (_translations.isNotEmpty) {
        await _saveToCache();
      }
    } catch (e) {
      debugPrint("Failed to load translations: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategory({
    required String host,
    required String path,
    required String category,
  }) async {
    try {
      final result = await TranslationService.getTranslations(
        host: host,
        path: path,
        category: category,
      );
      _translations.addAll(result);
    } catch (e) {
      debugPrint("Failed category $category: $e");
    }
  }

  String t(String key) {
    if (_translations.isEmpty) return key;

    final item = _translations.firstWhere(
      (e) => e.key == key,
      orElse: () => TranslationModel.empty(key),
    );

    switch (_currentLang) {
      case AppLanguage.tm:
        return item.tk ?? key;
      case AppLanguage.ru:
        return item.ru ?? key;
      case AppLanguage.en:
        return item.en ?? key;
    }
  }
}

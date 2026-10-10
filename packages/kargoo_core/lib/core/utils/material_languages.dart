import 'package:flutter_localizations/flutter_localizations.dart';

/// Language codes the built-in Material *and* Cupertino widgets have strings
/// for — the only ones safe to pass to `MaterialApp.locale`.
final Set<String> kMaterialSupportedLanguageCodes = kMaterialSupportedLanguages
    .intersection(kCupertinoSupportedLanguages);

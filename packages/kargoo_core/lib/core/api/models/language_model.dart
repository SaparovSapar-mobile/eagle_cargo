/// A language the client can pick, as served by
/// `GET /api/v1/translations/languages?firm_guid=...`.
///
/// The base languages (`tk`, `ru`, `en`) are available to every firm; on top
/// of them a firm may enable its own, which only its clients see.
class LanguageModel {
  final String code;

  /// Name written in the language itself ("Oʻzbekcha") — shown as is.
  final String name;

  /// ISO 3166-1 alpha-2 country code, for image flags.
  final String? country;

  /// Flag emoji; empty when the server sent none.
  final String flag;

  final bool isBase;

  /// Base language the server substitutes where a firm language has no
  /// translation. Always `null` for base languages.
  final String? fallback;

  const LanguageModel({
    required this.code,
    required this.name,
    this.country,
    this.flag = '',
    this.isBase = false,
    this.fallback,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    code: json['code'] ?? '',
    name: json['name'] ?? json['code'] ?? '',
    country: json['country'],
    flag: json['flag'] ?? '',
    isBase: json['is_base'] == true,
    fallback: json['fallback'],
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'country': country,
    'flag': flag,
    'is_base': isBase,
    'fallback': fallback,
  };

  /// Used until the server list (or its cache) is available.
  static const List<LanguageModel> base = [
    LanguageModel(
      code: 'tk',
      name: 'Türkmençe',
      country: 'TM',
      flag: '🇹🇲',
      isBase: true,
    ),
    LanguageModel(
      code: 'ru',
      name: 'Русский',
      country: 'RU',
      flag: '🇷🇺',
      isBase: true,
    ),
    LanguageModel(
      code: 'en',
      name: 'English',
      country: 'GB',
      flag: '🇬🇧',
      isBase: true,
    ),
  ];
}

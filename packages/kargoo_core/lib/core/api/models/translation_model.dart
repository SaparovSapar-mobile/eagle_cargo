class TranslationModel {
  String? key;
  String? category;

  /// Language code → text. Besides `tk`/`ru`/`en` a firm may add any number
  /// of its own languages, so the set of codes is not fixed.
  Map<String, String> values;

  TranslationModel({this.key, this.category, Map<String, String>? values})
    : values = values ?? {};

  /// Every field except `key` and `category` is a language code.
  TranslationModel.fromJson(Map<String, dynamic> json)
    : key = json['key'],
      category = json['category'],
      values = {
        for (final e in json.entries)
          if (e.key != 'key' && e.key != 'category' && e.value is String)
            e.key: e.value as String,
      };

  Map<String, dynamic> toJson() => {
    'key': key,
    'category': category,
    ...values,
  };

  /// Non-empty text for [lang], or `null`.
  String? get(String lang) {
    final text = values[lang];
    return (text == null || text.isEmpty) ? null : text;
  }
}

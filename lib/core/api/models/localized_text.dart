class LocalizedText {
  Map<String, String>? base;

  LocalizedText({this.base});

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      base: (json['base'] as Map?)?.map(
        (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    );
  }

  String get(String lang) {
    // Standard keys like title_en, desc_en, name_en, or just en
    return base?['title_$lang'] ??
        base?['desc_$lang'] ??
        base?['name_$lang'] ??
        base?[lang] ??
        "";
  }

  Map<String, dynamic> toJson() {
    return {'base': base};
  }
}

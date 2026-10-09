class LocalizedText {
  String? tk;
  String? ru;
  String? en;

  LocalizedText({this.tk, this.ru, this.en});

  LocalizedText.fromJson(Map<String, dynamic> json) {
    tk = json['tk'];
    ru = json['ru'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tk'] = tk;
    data['ru'] = ru;
    data['en'] = en;
    return data;
  }

  String get(String lang) {
    switch (lang) {
      case 'tk':
        return tk ?? "";
      case 'ru':
        return ru ?? "";
      case 'en':
        return en ?? "";
      default:
        return tk ?? "";
    }
  }
}

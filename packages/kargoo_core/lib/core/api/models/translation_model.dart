class TranslationModel {
  String? key;
  String? tk;
  String? en;
  String? ru;
  String? category;

  TranslationModel({this.key, this.tk, this.en, this.ru, this.category});

  TranslationModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    tk = json['tk'];
    en = json['en'];
    ru = json['ru'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['tk'] = tk;
    data['en'] = en;
    data['ru'] = ru;
    data['category'] = category;
    return data;
  }

  static TranslationModel empty(String key) =>
      TranslationModel(key: key, tk: key, en: key, ru: key, category: "");
}

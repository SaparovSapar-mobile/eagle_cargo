/// Kind of warning the firm published.
enum WarningType {
  /// The client must explicitly accept it before continuing.
  accept,

  /// Informational only.
  info,
}

class WarningModel {
  String? warningGuid;
  String? title;

  /// Rich text authored in the web panel — HTML, not plain text.
  String? content;
  WarningType type;
  int? level;
  String? updatedDt;

  WarningModel({
    this.warningGuid,
    this.title,
    this.content,
    this.type = WarningType.info,
    this.level,
    this.updatedDt,
  });

  WarningModel.fromJson(Map<String, dynamic> json)
      : type = json['type'] == 'accept' ? WarningType.accept : WarningType.info {
    warningGuid = json['warning_guid'];
    title = json['title'];
    content = json['content'];
    level = int.tryParse(json['level'].toString());
    updatedDt = json['updated_dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warning_guid'] = warningGuid;
    data['title'] = title;
    data['content'] = content;
    data['type'] = type.name;
    data['level'] = level;
    data['updated_dt'] = updatedDt;
    return data;
  }

  bool get mustAccept => type == WarningType.accept;
}

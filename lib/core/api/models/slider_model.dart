import 'localized_text.dart';

class SliderModel {
  String? sliderGuid;
  String? firmGuid;
  String? type;
  String? image;
  LocalizedText? title;
  LocalizedText? desc;
  String? webLink;
  String? appLink;
  int? level;
  int? second;

  SliderModel({
    this.sliderGuid,
    this.firmGuid,
    this.type,
    this.image,
    this.title,
    this.desc,
    this.webLink,
    this.appLink,
    this.level,
    this.second,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      sliderGuid: json['slider_guid'],
      firmGuid: json['firm_guid'],
      type: json['type'],
      image: json['image'],
      title: json['title'] != null ? LocalizedText.fromJson(json['title']) : null,
      desc: json['desc'] != null ? LocalizedText.fromJson(json['desc']) : null,
      webLink: json['web_link'],
      appLink: json['app_link'],
      level: json['level'],
      second: json['second'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider_guid': sliderGuid,
      'firm_guid': firmGuid,
      'type': type,
      'image': image,
      'title': title?.toJson(),
      'desc': desc?.toJson(),
      'web_link': webLink,
      'app_link': appLink,
      'level': level,
      'second': second,
    };
  }
}

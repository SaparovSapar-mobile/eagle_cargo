import 'package:kargoo_core/core/api/models/localized_text.dart';

class ProfileLocation {
  String? locationGuid;
  LocalizedText? name;
  String? emoji;

  ProfileLocation({this.locationGuid, this.name, this.emoji});

  ProfileLocation.fromJson(Map<String, dynamic> json) {
    locationGuid = json['location_guid'];
    name = json['name'] != null ? LocalizedText.fromJson(json['name']) : null;
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_guid'] = locationGuid;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    data['emoji'] = emoji;
    return data;
  }
}

class User {
  String? userGuid;
  String? login;
  String? phone;
  String? fullname;
  String? email;
  String? role;
  bool? isVerified;
  ProfileLocation? location;

  User({
    this.userGuid,
    this.login,
    this.phone,
    this.fullname,
    this.email,
    this.role,
    this.isVerified,
    this.location,
  });

  User.fromJson(Map<String, dynamic> json) {
    userGuid = json['user_guid'];
    login = json['login'];
    phone = json['phone'];
    fullname = json['fullname'];
    email = json['email'];
    role = json['role'];
    isVerified = json['is_verified'];
    location =
        json['location'] != null
            ? ProfileLocation.fromJson(json['location'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_guid'] = userGuid;
    data['login'] = login;
    data['phone'] = phone;
    data['fullname'] = fullname;
    data['email'] = email;
    data['role'] = role;
    data['is_verified'] = isVerified;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

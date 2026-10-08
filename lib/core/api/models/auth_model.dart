import 'package:kargoo_core/kargoo_core.dart' hide Palette, PreferenceManager, PreferenceKeys;

class AuthModel {
  String? message, status;
  User? user;
  String? accessToken;

  AuthModel({this.status, this.message, this.user, this.accessToken});

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
  }
}
